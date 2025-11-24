/// Represents a user's learning progress and achievements.
///
/// This data class tracks key progress metrics including experience points,
/// daily streaks, and challenge completion counts. It supports JSON
/// serialization for API communication and data persistence.
class UserProgress {
  /// Unique identifier of the user
  final int userId;

  /// Total experience points earned by the user
  final int totalXp;

  /// Current consecutive days of activity streak
  final int currentStreak;

  /// Total number of challenges successfully completed
  final int challengesCompleted;

  /// Date of the last challenge completed in string format (optional)
  final String? lastChallengeDate;

  final String? achievementsData;

  UserProgress({
    required this.userId,
    required this.totalXp,
    required this.currentStreak,
    required this.challengesCompleted,
    this.lastChallengeDate,
    this.achievementsData,
  });

  /// Creates a UserProgress instance from JSON data.
  ///
  /// Used to deserialize data from API responses or local storage.
  /// Expects JSON keys to match the field names with snake_case convention.
  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['user_id'],
      totalXp: json['total_xp'],
      currentStreak: json['current_streak'],
      challengesCompleted: json['challenges_completed'],
      lastChallengeDate: json['last_challenge_date'],
      achievementsData: json['achievements_data'],
    );
  }

  /// Converts this UserProgress instance to JSON format.
  ///
  /// Used for serializing data for API requests or local storage.
  /// Returns a Map with snake_case keys as expected by most backend APIs.
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'total_xp': totalXp,
      'current_streak': currentStreak,
      'challenges_completed': challengesCompleted,
      'last_challenge_date': lastChallengeDate,
      'achievements_data': achievementsData,
    };
  }

  /// Creates a copy of this UserProgress with the specified fields replaced.
  ///
  /// This is useful for creating modified versions of user progress data
  /// while maintaining immutability of the original object.
  UserProgress copyWith({
    int? userId,
    int? totalXp,
    int? currentStreak,
    int? challengesCompleted,
    String? lastChallengeDate,
    String? achievementsData,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      totalXp: totalXp ?? this.totalXp,
      currentStreak: currentStreak ?? this.currentStreak,
      challengesCompleted: challengesCompleted ?? this.challengesCompleted,
      lastChallengeDate: lastChallengeDate ?? this.lastChallengeDate,
      achievementsData: achievementsData ?? this.achievementsData,
    );
  }
}
