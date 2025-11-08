import 'dart:convert';
import 'package:http/http.dart' as http;

class AudioApiService {
  // Update based on your platform
  // iOS Simulator: http://localhost:8000/api
  // Android Emulator: http://10.0.2.2:8000/api
  // Physical Device: http://YOUR_IP:8000/api
  static const String baseUrl = 'http://localhost:8000/api';

  /// Get available difficulty levels
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

  /// Generate a new audio challenge
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

  /// Submit answer for audio challenge
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

  /// Get audio URL for specific option
  String getAudioUrl(int challengeId, String optionLetter) {
    return '$baseUrl/challenge/audio/$challengeId/option/$optionLetter';
  }
}

// Models

class Difficulty {
  final String id;
  final String name;
  final String description;
  final int xpReward;
  final String icon;

  Difficulty({
    required this.id,
    required this.name,
    required this.description,
    required this.xpReward,
    required this.icon,
  });

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

class AudioOption {
  final String letter;
  final String audioUrl;
  final String pattern;

  AudioOption({
    required this.letter,
    required this.audioUrl,
    required this.pattern,
  });

  factory AudioOption.fromJson(Map<String, dynamic> json) {
    return AudioOption(
      letter: json['letter'],
      audioUrl: json['audio_url'],
      pattern: json['pattern'],
    );
  }
}

class AudioChallenge {
  final int id;
  final String word;
  final String difficulty;
  final String content;
  final String type;
  final int xpReward;
  final String? hint;
  final List<AudioOption> options;
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

  String getAudioUrl(String optionLetter) {
    final baseUrl = AudioApiService.baseUrl;
    return '$baseUrl/challenge/audio/$id/option/$optionLetter';
  }
}

class AudioChallengeResult {
  final int challengeId;
  final int userId;
  final bool isCorrect;
  final int xpEarned;
  final String feedback;
  final String correctAnswer;
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
