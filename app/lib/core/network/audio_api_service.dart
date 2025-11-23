import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for interacting with the audio challenge backend API.
/// 
/// Handles all audio-related operations including:
/// - Difficulty level management
/// - Audio challenge generation
/// - Answer submission and validation
/// - Audio file URL generation
/// 
/// Note: Base URL configuration varies by platform:
/// - iOS Simulator: http://localhost:8000/api
/// - Android Emulator: http://10.0.2.2:8000/api  
/// - Physical Device: http://YOUR_IP:8000/api
class AudioApiService {
  // Update based on your platform
  // iOS Simulator: http://localhost:8000/api
  // Android Emulator: http://10.0.2.2:8000/api
  // Physical Device: http://YOUR_IP:8000/api
  static const String baseUrl = 'http://localhost:8000/api';

  /// Retrieves available difficulty levels for audio challenges.
  /// 
  /// Fetches the list of difficulty settings from the backend API
  /// including names, descriptions, XP rewards, and icons.
  /// 
  /// Returns [List<Difficulty>] - Available difficulty levels
  /// Throws [Exception] on network errors or non-200 responses
  Future<List<Difficulty>> getDifficulties() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/difficulties'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> difficulties = data['difficulties'];
        return difficulties.map((json) => Difficulty.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load difficulties: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching difficulties: $e');
    }
  }

  /// Generates a new audio challenge with the specified difficulty.
  /// 
  /// [difficulty]: The difficulty level for the challenge (e.g., 'easy', 'medium')
  /// 
  /// Returns [AudioChallenge] - Generated challenge with audio options and metadata
  /// Throws [Exception] on network errors or non-200 responses
  Future<AudioChallenge> generateAudioChallenge(String difficulty) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/challenge/audio/generate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'difficulty': difficulty}),
      );

      if (response.statusCode == 200) {
        return AudioChallenge.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to generate challenge: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating challenge: $e');
    }
  }

  /// Submits an answer for an audio challenge and gets validation results.
  /// 
  /// [challengeId]: The ID of the challenge being answered
  /// [answer]: The user's answer (typically a letter like 'A', 'B', etc.)
  /// [userId]: The ID of the user submitting the answer
  /// 
  /// Returns [AudioChallengeResult] - Validation result with correctness, XP, and feedback
  /// Throws [Exception] on network errors or non-200 responses
  Future<AudioChallengeResult> submitAudioAnswer(
    int challengeId,
    String answer,
    int userId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/challenge/audio/$challengeId/submit'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_answer': answer, 'user_id': userId}),
      );

      if (response.statusCode == 200) {
        return AudioChallengeResult.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to submit answer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting answer: $e');
    }
  }

  /// Generates the audio URL for a specific challenge option.
  /// 
  /// [challengeId]: The ID of the challenge
  /// [optionLetter]: The letter identifier of the option (e.g., 'A', 'B')
  /// 
  /// Returns [String] - Full URL to the audio file for playback
  String getAudioUrl(int challengeId, String optionLetter) {
    return '$baseUrl/challenge/audio/$challengeId/option/$optionLetter';
  }
}

// ===========================================================================
// DATA MODELS
// ===========================================================================

/// Represents a difficulty level for audio challenges.
class Difficulty {
  /// Unique identifier for the difficulty level
  final String id;
  
  /// Display name (e.g., 'Easy', 'Medium', 'Hard')
  final String name;
  
  /// Description of what this difficulty entails
  final String description;
  
  /// XP reward for completing challenges at this difficulty
  final int xpReward;
  
  /// Icon identifier for UI representation
  final String icon;

  Difficulty({
    required this.id,
    required this.name,
    required this.description,
    required this.xpReward,
    required this.icon,
  });

  /// Creates a Difficulty instance from JSON data.
  factory Difficulty.fromJson(Map<String, dynamic> json) {
    return Difficulty(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      xpReward: json['xp_reward'],
      icon: json['icon'],
    );
  }
}

/// Represents an individual audio option within a challenge.
class AudioOption {
  /// Letter identifier for the option (A, B, C, etc.)
  final String letter;
  
  /// URL to the audio file for this option
  final String audioUrl;
  
  /// Pattern or phonetic representation of the audio content
  final String pattern;

  AudioOption({
    required this.letter,
    required this.audioUrl,
    required this.pattern,
  });

  /// Creates an AudioOption instance from JSON data.
  factory AudioOption.fromJson(Map<String, dynamic> json) {
    return AudioOption(
      letter: json['letter'],
      audioUrl: json['audio_url'],
      pattern: json['pattern'],
    );
  }
}

/// Represents a complete audio challenge with all options and metadata.
class AudioChallenge {
  /// Unique identifier for the challenge
  final int id;
  
  /// The target word or concept being tested
  final String word;
  
  /// Difficulty level of the challenge
  final String difficulty;
  
  /// Content or instruction for the challenge
  final String content;
  
  /// Type of audio challenge
  final String type;
  
  /// XP reward for correct completion
  final int xpReward;
  
  /// Optional hint to assist the user
  final String? hint;
  
  /// List of available audio options to choose from
  final List<AudioOption> options;
  
  /// The correct answer (option letter)
  final String correctAnswer;

  AudioChallenge({
    required this.id,
    required this.word,
    required this.difficulty,
    required this.content,
    required this.type,
    required this.xpReward,
    this.hint,
    required this.options,
    required this.correctAnswer,
  });

  /// Creates an AudioChallenge instance from JSON data.
  factory AudioChallenge.fromJson(Map<String, dynamic> json) {
    return AudioChallenge(
      id: json['id'],
      word: json['word'],
      difficulty: json['difficulty'],
      content: json['content'],
      type: json['type'],
      xpReward: json['xp_reward'],
      hint: json['hint'],
      options: (json['options'] as List)
          .map((opt) => AudioOption.fromJson(opt))
          .toList(),
      correctAnswer: json['correct_answer'],
    );
  }

  /// Generates the audio URL for a specific option in this challenge.
  /// 
  /// [optionLetter]: The letter identifier of the option
  /// Returns [String] - Full URL to the option's audio file
  String getAudioUrl(String optionLetter) {
    final baseUrl = AudioApiService.baseUrl;
    return '$baseUrl/challenge/audio/$id/option/$optionLetter';
  }
}

/// Represents the result of submitting an answer to an audio challenge.
class AudioChallengeResult {
  /// ID of the challenge that was answered
  final int challengeId;
  
  /// ID of the user who submitted the answer
  final int userId;
  
  /// Whether the answer was correct
  final bool isCorrect;
  
  /// XP earned from this attempt
  final int xpEarned;
  
  /// Feedback message explaining the result
  final String feedback;
  
  /// The correct answer for the challenge
  final String correctAnswer;
  
  /// The correct word or concept
  final String correctWord;

  AudioChallengeResult({
    required this.challengeId,
    required this.userId,
    required this.isCorrect,
    required this.xpEarned,
    required this.feedback,
    required this.correctAnswer,
    required this.correctWord,
  });

  /// Creates an AudioChallengeResult instance from JSON data.
  factory AudioChallengeResult.fromJson(Map<String, dynamic> json) {
    return AudioChallengeResult(
      challengeId: json['challenge_id'],
      userId: json['user_id'],
      isCorrect: json['is_correct'],
      xpEarned: json['xp_earned'],
      feedback: json['feedback'],
      correctAnswer: json['correct_answer'],
      correctWord: json['correct_word'],
    );
  }
}
