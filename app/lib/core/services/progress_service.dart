import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/user_progress.dart';
import '../data/models/quiz_attempt.dart';
import '../data/models/user_progress_stats.dart';

class ProgressService {
  final SupabaseClient _supabase = Supabase.instance.client;

  int get _userId {
    final user = _supabase.auth.currentUser;
    if (user == null) return 1; // Fallback for testing
    // Convert Supabase UUID to int for database compatibility
    return user.id.hashCode.abs();
  }

  /// Get user progress from Supabase
  Future<UserProgress?> getUserProgress() async {
    try {
      final response = await _supabase
          .from('user_progress')
          .select('*')
          .eq('user_id', _userId)
          .single();

      if (response.isEmpty) return null;

      return UserProgress.fromJson(response);
    } catch (e) {
      // If no record exists, return null
      if (e.toString().contains('No rows found')) {
        return null;
      }
      rethrow;
    }
  }

  /// Save or update user progress in Supabase
  Future<void> saveUserProgress(UserProgress progress) async {
    final data = progress.toJson();
    data['user_id'] = _userId;

    await _supabase.from('user_progress').upsert(data);
  }

  /// Create a new quiz attempt record
  Future<void> createQuizAttempt(QuizAttempt attempt) async {
    final data = attempt.toJson();
    data['user_id'] = _userId;

    await _supabase.from('quiz_attempts').insert(data);
  }

  /// Get quiz attempts for statistics calculation
  Future<List<QuizAttempt>> getQuizAttempts({
    DateTime? since,
    int? limit,
  }) async {
    final response = await _supabase
        .from('quiz_attempts')
        .select('*')
        .eq('user_id', _userId)
        .order('created_at', ascending: false)
        .limit(limit ?? 1000); // Reasonable limit

    var attempts = response.map((json) => QuizAttempt.fromJson(json)).toList();

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
  }

  /// Initialize progress for new user
  Future<UserProgress> initializeUserProgress() async {
    final progress = UserProgress(
      userId: _userId,
      totalXp: 0,
      currentStreak: 0,
      challengesCompleted: 0,
      lastChallengeDate: null,
    );

    await saveUserProgress(progress);
    return progress;
  }

  /// Calculate comprehensive progress statistics
  Future<UserProgressStats> getProgressStats() async {
    final progress = await getUserProgress();
    if (progress == null) {
      return UserProgressStats.empty(_userId);
    }

    final allAttempts = await getQuizAttempts();
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final weeklyAttempts = await getQuizAttempts(since: weekAgo);

    return UserProgressStats.calculate(progress, allAttempts, weeklyAttempts);
  }
}
