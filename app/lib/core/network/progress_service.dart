import 'package:supabase_flutter/supabase_flutter.dart';
import '../common/user_progress.dart';
import '../common/quiz_attempt.dart';
import '../common/user_progress_stats.dart';

class ProgressService {
  final SupabaseClient _supabase = Supabase.instance.client;
  static final List<QuizAttempt> historyList = [];

  int? get _userId {
    final user = _supabase.auth.currentUser;
    if (user == null) return null; // Guest user - no authenticated user
    // Convert Supabase UUID to int for database compatibility
    return user.id.hashCode.abs();
  }

  bool get _isGuest => _supabase.auth.currentUser == null;

  bool get isGuest => _isGuest;

  /// Get user progress from Supabase
  /// Returns null for guest users to prevent unauthorized data access
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

  /// Save or update user progress in Supabase
  /// Does nothing for guest users to prevent unauthorized writes
  Future<void> saveUserProgress(UserProgress progress) async {
    if (_isGuest) {
      return; // Don't save progress for guests
    }

    try {
      final data = progress.toJson();
      data['user_id'] = _userId!;

      await _supabase.from('user_progress').upsert(data);
    } catch (e) {
      if (isMissingTable(e, 'user_progress')) {
        return;
      }
      rethrow;
    }
  }

  /// Create a new quiz attempt record
  /// Does nothing for guest users to prevent unauthorized writes
  Future<void> createQuizAttempt(QuizAttempt attempt) async {
    if (_isGuest) {
      saveAttempt(attempt);
      return; // Don't save attempts for guests
    }

    try {
      final data = attempt.toJson();
      data['user_id'] = _userId!;

      await _supabase.from('quiz_attempts').insert(data);
    } catch (e) {
      if (isMissingTable(e, 'quiz_attempts')) {
        saveAttempt(attempt);
        return;
      }
      rethrow;
    }
    saveAttempt(attempt);
  }

  /// Get quiz attempts for statistics calculation
  /// Returns empty list for guest users
  Future<List<QuizAttempt>> getQuizAttempts({
    DateTime? since,
    int? limit,
  }) async {
    if (_isGuest) {
      return List.unmodifiable(historyList); // Guests have no attempts
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

      if (attempts.isEmpty) {
        return List.unmodifiable(historyList);
      }

      return attempts;
    } catch (e) {
      return List.unmodifiable(historyList);
    }
  }

  /// Initialize progress for new user
  /// Returns dummy progress for guests without saving
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

  /// Calculate comprehensive progress statistics
  /// Returns empty stats for guest users
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

  /// Get days with practice activity for the current month
  /// Returns set of day numbers (1-31) that have quiz attempts
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

  /// Clear any cached guest data (call this when user logs in/out)
  Future<void> clearGuestData() async {
    // This method can be used to explicitly clear any in-memory cached data
    // if your app implements caching
  }

  bool isMissingTable(Object error, String tableName) {
    if (error is PostgrestException) {
      final message = error.message ?? '';
      return message.contains("table 'public.$tableName'");
    }
    return false;
  }

  void saveAttempt(QuizAttempt attempt) {
    historyList.insert(0, attempt);
    if (historyList.length > 50) {
      historyList.removeLast();
    }
  }
}
