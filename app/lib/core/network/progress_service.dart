import 'package:supabase_flutter/supabase_flutter.dart';
import '../common/user_progress.dart';
import '../common/quiz_attempt.dart';
import '../common/user_progress_stats.dart';

/// Service for managing user progress data and quiz attempts in Supabase.
/// 
/// This service handles all progress-related operations including:
/// - User progress tracking (XP, streaks, challenges)
/// - Quiz attempt recording and retrieval
/// - Progress statistics calculation
/// - Guest user support with local-only progress
/// 
/// Automatically handles authentication state and prevents unauthorized
/// database access for guest users.
class ProgressService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Gets the current user ID as an integer for database compatibility.
  /// 
  /// Converts Supabase UUID to integer hash code. Returns null for guest users.
  int? get _userId {
    final user = _supabase.auth.currentUser;
    if (user == null) return null; // Guest user - no authenticated user
    // Convert Supabase UUID to int for database compatibility
    return user.id.hashCode.abs();
  }

  /// Checks if the current user is a guest (not authenticated).
  bool get _isGuest => _supabase.auth.currentUser == null;

  /// Public accessor for guest status check.
  bool get isGuest => _isGuest;

  /// Retrieves user progress from Supabase database.
  /// 
  /// Returns the user's progress data including XP, streaks, and challenge
  /// completions. Returns null for guest users or if no progress record exists.
  /// 
  /// Returns [UserProgress?] - User progress data or null if not found/guest
  Future<UserProgress?> getUserProgress() async {
    if (_isGuest) {
      return null; // Guests have no progress
    }

    try {
      final response = await _supabase
          .from('user_progress')
          .select('*')
          .eq('user_id', _userId!)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return UserProgress.fromJson(response);
    } catch (e) {
      // If no record exists or any other error, return null
      return null;
    }
  }

  /// Saves or updates user progress in Supabase database.
  /// 
  /// [progress]: The UserProgress object to save
  /// 
  /// Uses upsert to create or update the progress record. Does nothing
  /// for guest users to prevent unauthorized database writes.
  /// 
  /// Throws exceptions from Supabase on database errors.
  Future<void> saveUserProgress(UserProgress progress) async {
    if (_isGuest) {
      return; // Don't save progress for guests
    }

    try {
      final data = progress.toJson();
      data['user_id'] = _userId!;

      await _supabase.from('user_progress').upsert(data);
    } catch (e) {
      rethrow;
    }
  }

  /// Records a new quiz attempt in the database.
  /// 
  /// [attempt]: The QuizAttempt object to record
  /// 
  /// Stores the attempt with user answer, correctness, and XP earned.
  /// Does nothing for guest users to prevent unauthorized writes.
  /// 
  /// Throws exceptions from Supabase on database errors.
  Future<void> createQuizAttempt(QuizAttempt attempt) async {
    if (_isGuest) {
      return; // Don't save attempts for guests
    }

    try {
      final data = attempt.toJson();
      data['user_id'] = _userId!;

      await _supabase.from('quiz_attempts').insert(data);
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves quiz attempts for statistics calculation and history.
  /// 
  /// [since]: Optional filter for attempts since specific date
  /// [limit]: Optional limit for number of attempts to return
  /// 
  /// Returns list of quiz attempts, ordered by most recent first.
  /// Returns empty list for guest users or on error.
  /// 
  /// Returns [List<QuizAttempt>] - List of quiz attempts
  Future<List<QuizAttempt>> getQuizAttempts({
    DateTime? since,
    int? limit,
  }) async {
    if (_isGuest) {
      return []; // Guests have no attempts
    }

    try {
      final response = await _supabase
          .from('quiz_attempts')
          .select('*')
          .eq('user_id', _userId!)
          .order('created_at', ascending: false)
          .limit(limit ?? 1000); // Reasonable limit

      var attempts = (response as List)
          .map((json) => QuizAttempt.fromJson(json as Map<String, dynamic>))
          .toList();

      // Filter by date in Dart if needed
      if (since != null) {
        attempts = attempts
            .where((attempt) => attempt.createdAt.isAfter(since))
            .toList();
      }

      // Apply limit after filtering
      if (limit != null && attempts.length > limit) {
        attempts = attempts.take(limit).toList();
      }

      return attempts;
    } catch (e) {
      return [];
    }
  }

  /// Initializes progress data for a new user.
  /// 
  /// Creates a new progress record with zero values. For guest users,
  /// returns a dummy progress object that is not persisted to database.
  /// 
  /// Returns [UserProgress] - Initialized progress data
  Future<UserProgress> initializeUserProgress() async {
    if (_isGuest) {
      // Return a dummy progress for guests (not saved to database)
      return UserProgress(
        userId: 0, // Dummy ID for guests
        totalXp: 0,
        currentStreak: 0,
        challengesCompleted: 0,
        lastChallengeDate: null,
      );
    }

    try {
      final progress = UserProgress(
        userId: _userId!,
        totalXp: 0,
        currentStreak: 0,
        challengesCompleted: 0,
        lastChallengeDate: null,
      );

      await saveUserProgress(progress);
      return progress;
    } catch (e) {
      rethrow;
    }
  }

  /// Calculates comprehensive progress statistics and analytics.
  /// 
  /// Combines progress data with quiz attempts to generate detailed
  /// statistics including accuracy rates, streaks, and improvements.
  /// Returns empty stats for guest users or on error.
  /// 
  /// Returns [UserProgressStats] - Comprehensive progress statistics
  Future<UserProgressStats> getProgressStats() async {
    if (_isGuest) {
      return UserProgressStats.empty(0); // Guest user ID = 0
    }

    try {
      final progress = await getUserProgress();
      if (progress == null) {
        return UserProgressStats.empty(_userId!);
      }

      final allAttempts = await getQuizAttempts();
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      final weeklyAttempts = await getQuizAttempts(since: weekAgo);

      final stats = UserProgressStats.calculate(
        progress,
        allAttempts,
        weeklyAttempts,
      );
      return stats;
    } catch (e) {
      // Return empty stats on error rather than crashing
      return UserProgressStats.empty(_userId ?? 0);
    }
  }

  /// Gets days in the current month that have practice activity.
  /// 
  /// Useful for calendar views and streak visualization. Returns
  /// a set of day numbers (1-31) that have quiz attempts.
  /// Returns empty set for guest users or on error.
  /// 
  /// Returns [Set<int>] - Set of days with practice activity
  Future<Set<int>> getPracticeDaysForCurrentMonth() async {
    if (_isGuest) {
      return {}; // Guests have no practice days
    }

    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      final response = await _supabase
          .from('quiz_attempts')
          .select('created_at')
          .eq('user_id', _userId!)
          .gte('created_at', startOfMonth.toIso8601String())
          .lte('created_at', endOfMonth.toIso8601String());

      final attempts = response as List;
      final practiceDays = <int>{};

      for (final attempt in attempts) {
        final createdAt = DateTime.parse(attempt['created_at'] as String);
        practiceDays.add(createdAt.day);
      }

      return practiceDays;
    } catch (e) {
      return {};
    }
  }

  /// Clears any cached guest data when user authentication state changes.
  /// 
  /// Call this method when users log in or out to ensure clean state
  /// transitions between guest and authenticated modes.
  Future<void> clearGuestData() async {
    // This method can be used to explicitly clear any in-memory cached data
    // if your app implements caching
  }
}
