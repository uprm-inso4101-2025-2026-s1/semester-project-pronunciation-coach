import 'user_progress.dart';
import 'quiz_attempt.dart';

/// Comprehensive user progress statistics and analytics data model.
/// 
/// This class aggregates and calculates various user performance metrics
/// including XP, streaks, accuracy rates, session counts, and improvement
/// trends over time. It provides both current stats and comparative analytics.
class UserProgressStats {
  /// Unique identifier of the user
  final int userId;
  
  /// Total experience points earned by the user
  final int totalXp;
  
  /// Current consecutive days of activity streak
  final int currentStreak;
  
  /// Total number of challenges successfully completed
  final int challengesCompleted;
  
  /// Overall accuracy rate as a percentage (0-100)
  final double accuracyRate;
  
  /// Total number of words/items practiced across all attempts
  final int wordsPracticed;
  
  /// Number of unique days the user has practiced
  final int sessionsCount;
  
  /// Average score formatted as a percentage string (e.g., "85.5%")
  final String avgScore;
  
  /// Count of recent correct answers (typically last 10 attempts)
  final int improvedCount;
  
  /// Highest consecutive correct streak achieved this week
  final int highestStreak;
  
  /// Week-over-week accuracy improvement percentage
  final double accuracyImprovement;
  
  /// Week-over-week words practiced improvement percentage
  final double wordsImprovement;

  UserProgressStats({
    required this.userId,
    required this.totalXp,
    required this.currentStreak,
    required this.challengesCompleted,
    required this.accuracyRate,
    required this.wordsPracticed,
    required this.sessionsCount,
    required this.avgScore,
    required this.improvedCount,
    required this.highestStreak,
    required this.accuracyImprovement,
    required this.wordsImprovement,
  });

  /// Creates an empty UserProgressStats instance for a new user.
  /// 
  /// [userId]: The user ID to associate with the empty stats
  /// Returns a UserProgressStats with all values initialized to zero
  factory UserProgressStats.empty(int userId) {
    return UserProgressStats(
      userId: userId,
      totalXp: 0,
      currentStreak: 0,
      challengesCompleted: 0,
      accuracyRate: 0.0,
      wordsPracticed: 0,
      sessionsCount: 0,
      avgScore: "0%",
      improvedCount: 0,
      highestStreak: 0,
      accuracyImprovement: 0.0,
      wordsImprovement: 0.0,
    );
  }

  /// Calculates comprehensive user statistics from progress and quiz attempt data.
  /// 
  /// This method processes user progress and quiz attempts to generate detailed
  /// analytics including accuracy rates, streaks, session counts, and week-over-week
  /// improvements.
  /// 
  /// [progress]: The user's basic progress information
  /// [allAttempts]: All quiz attempts made by the user
  /// [weeklyAttempts]: Quiz attempts from the current week for weekly metrics
  /// 
  /// Returns a fully populated UserProgressStats instance with calculated metrics
  static UserProgressStats calculate(
    UserProgress progress,
    List<QuizAttempt> allAttempts,
    List<QuizAttempt> weeklyAttempts,
  ) {
    final totalAttempts = allAttempts.length;
    final correctAttempts = allAttempts.where((a) => a.isCorrect).length;
    final accuracyRate = totalAttempts > 0
        ? (correctAttempts / totalAttempts * 100)
        : 0.0;

    // Calculate sessions (unique practice days)
    final sessionsDates = <String>{};
    for (final attempt in allAttempts) {
      final dateStr = attempt.createdAt.toIso8601String().split('T')[0];
      sessionsDates.add(dateStr);
    }
    final sessionsCount = sessionsDates.length;

    // Weekly accuracy
    final weeklyCorrect = weeklyAttempts.where((a) => a.isCorrect).length;
    final weeklyTotal = weeklyAttempts.length;
    final weeklyAccuracy = weeklyTotal > 0
        ? (weeklyCorrect / weeklyTotal * 100)
        : 0.0;

    // Calculate week-over-week improvements
    double accuracyImprovement = 0.0;
    double wordsImprovement = 0.0;

    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));
    final twoWeeksAgo = now.subtract(const Duration(days: 14));

    // This week's attempts (last 7 days)
    final thisWeekAttempts = allAttempts
        .where((attempt) => attempt.createdAt.isAfter(oneWeekAgo))
        .toList();

    // Last week's attempts (8-14 days ago)
    final lastWeekAttempts = allAttempts
        .where(
          (attempt) =>
              attempt.createdAt.isAfter(twoWeeksAgo) &&
              attempt.createdAt.isBefore(oneWeekAgo),
        )
        .toList();

    if (thisWeekAttempts.isNotEmpty && lastWeekAttempts.isNotEmpty) {
      // This week's accuracy
      final thisWeekCorrect = thisWeekAttempts.where((a) => a.isCorrect).length;
      final thisWeekTotal = thisWeekAttempts.length;
      final thisWeekAccuracy = thisWeekTotal > 0
          ? (thisWeekCorrect / thisWeekTotal * 100)
          : 0.0;

      // Last week's accuracy
      final lastWeekCorrect = lastWeekAttempts.where((a) => a.isCorrect).length;
      final lastWeekTotal = lastWeekAttempts.length;
      final lastWeekAccuracy = lastWeekTotal > 0
          ? (lastWeekCorrect / lastWeekTotal * 100)
          : 0.0;

      // Calculate improvement (this week - last week)
      accuracyImprovement = thisWeekAccuracy - lastWeekAccuracy;

      // Words improvement (this week vs last week)
      wordsImprovement =
          ((thisWeekAttempts.length - lastWeekAttempts.length) /
              lastWeekAttempts.length) *
          100;
    }

    // Recent correct count (correct answers in recent attempts)
    final recentCorrectCount = allAttempts
        .take(10)
        .where((a) => a.isCorrect)
        .length;

    // Calculate highest streak this week
    int highestStreak = 0;
    if (thisWeekAttempts.isNotEmpty) {
      // Sort attempts by date for streak calculation
      final sortedAttempts = thisWeekAttempts
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

      int currentStreak = 0;
      for (final attempt in sortedAttempts) {
        if (attempt.isCorrect) {
          currentStreak++;
          highestStreak = currentStreak > highestStreak
              ? currentStreak
              : highestStreak;
        } else {
          currentStreak = 0;
        }
      }
    }

    return UserProgressStats(
      userId: progress.userId,
      totalXp: progress.totalXp,
      currentStreak: progress.currentStreak,
      challengesCompleted: progress.challengesCompleted,
      accuracyRate: accuracyRate,
      wordsPracticed: totalAttempts,
      sessionsCount: sessionsCount,
      avgScore: "${weeklyAccuracy.toStringAsFixed(1)}%",
      improvedCount: recentCorrectCount,
      highestStreak: highestStreak,
      accuracyImprovement: accuracyImprovement,
      wordsImprovement: wordsImprovement,
    );
  }

  /// Converts the UserProgressStats instance to a JSON-serializable map.
  /// 
  /// Returns a Map with snake_case keys suitable for API communication
  /// or local storage. All numeric values are preserved as-is.
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'total_xp': totalXp,
      'current_streak': currentStreak,
      'challenges_completed': challengesCompleted,
      'accuracy_rate': accuracyRate,
      'words_practiced': wordsPracticed,
      'sessions_count': sessionsCount,
      'avg_score': avgScore,
      'improved_count': improvedCount,
      'accuracy_improvement': accuracyImprovement,
      'words_improvement': wordsImprovement,
    };
  }
}