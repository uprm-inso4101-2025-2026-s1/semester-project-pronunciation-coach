class UserProgress {
  final int userId;
  final int totalXp;
  final int currentStreak;
  final int challengesCompleted;
  final String? lastChallengeDate;

  UserProgress({
    required this.userId,
    required this.totalXp,
    required this.currentStreak,
    required this.challengesCompleted,
    this.lastChallengeDate,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['user_id'],
      totalXp: json['total_xp'],
      currentStreak: json['current_streak'],
      challengesCompleted: json['challenges_completed'],
      lastChallengeDate: json['last_challenge_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'total_xp': totalXp,
      'current_streak': currentStreak,
      'challenges_completed': challengesCompleted,
      'last_challenge_date': lastChallengeDate,
    };
  }

  UserProgress copyWith({
    int? userId,
    int? totalXp,
    int? currentStreak,
    int? challengesCompleted,
    String? lastChallengeDate,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      totalXp: totalXp ?? this.totalXp,
      currentStreak: currentStreak ?? this.currentStreak,
      challengesCompleted: challengesCompleted ?? this.challengesCompleted,
      lastChallengeDate: lastChallengeDate ?? this.lastChallengeDate,
    );
  }
}
