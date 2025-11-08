class QuizAttempt {
  final int userId;
  final int challengeId;
  final String difficulty;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final int xpEarned;
  final DateTime createdAt;

  QuizAttempt({
    required this.userId,
    required this.challengeId,
    required this.difficulty,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.xpEarned,
    required this.createdAt,
  });

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      userId: json['user_id'],
      challengeId: json['challenge_id'],
      difficulty: json['difficulty'],
      userAnswer: json['user_answer'],
      correctAnswer: json['correct_answer'],
      isCorrect: json['is_correct'],
      xpEarned: json['xp_earned'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'challenge_id': challengeId,
      'difficulty': difficulty,
      'user_answer': userAnswer,
      'correct_answer': correctAnswer,
      'is_correct': isCorrect,
      'xp_earned': xpEarned,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
