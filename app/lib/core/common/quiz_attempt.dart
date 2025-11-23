/// Represents a user's attempt at a quiz challenge.
/// 
/// This class encapsulates all data related to a single quiz attempt including
/// user answers, correctness, earned XP, and metadata. It provides JSON
/// serialization/deserialization for API communication and data persistence.
class QuizAttempt {
  /// Unique identifier of the user who made this attempt
  final int userId;
  
  /// Unique identifier of the challenge that was attempted
  final int challengeId;
  
  /// Difficulty level of the quiz (e.g., 'easy', 'medium', 'hard')
  final String difficulty;
  
  /// The answer provided by the user
  final String userAnswer;
  
  /// The correct answer for the quiz challenge
  final String correctAnswer;
  
  /// Whether the user's answer was correct
  final bool isCorrect;
  
  /// Experience points earned from this attempt
  final int xpEarned;
  
  /// Timestamp when the attempt was made
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

  /// Creates a QuizAttempt instance from JSON data.
  /// 
  /// Used to deserialize data from API responses or local storage.
  /// Expects JSON keys to match the field names with snake_case convention.
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

  /// Converts this QuizAttempt instance to JSON format.
  /// 
  /// Used for serializing data for API requests or local storage.
  /// Returns a Map with snake_case keys as expected by most backend APIs.
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
