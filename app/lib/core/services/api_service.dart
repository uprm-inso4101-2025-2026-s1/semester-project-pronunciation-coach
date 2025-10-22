// lib/core/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';

class ApiService {
  // Use the appropriate base URL based on your platform
  // For iOS Simulator: http://localhost:8000/api
  // For Android Emulator: http://10.0.2.2:8000/api
  // For Physical Device: http://YOUR_COMPUTER_IP:8000/api
  static const String baseUrl = 'http://localhost:8000/api';

  // Get all challenges
  Future<List<Challenge>> getChallenges() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/challenges'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Challenge.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load challenges: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching challenges: $e');
    }
  }

  // Get daily challenge
  Future<Challenge> getDailyChallenge() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/challenge/daily'));
      
      if (response.statusCode == 200) {
        return Challenge.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load daily challenge: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching daily challenge: $e');
    }
  }

  // Get challenge by ID
  Future<Challenge> getChallengeById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/challenge/$id'));
      
      if (response.statusCode == 200) {
        return Challenge.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load challenge: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching challenge: $e');
    }
  }

  // Submit multiple choice answer
  Future<ChallengeResult> submitMultipleChoiceAnswer(
    int challengeId,
    String answer,
    int userId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/challenge/$challengeId/submit'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_answer': answer,
          'user_id': userId,
        }),
      );
      
      if (response.statusCode == 200) {
        return ChallengeResult.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to submit answer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting answer: $e');
    }
  }

  // Get user progress
  Future<UserProgress> getUserProgress(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/progress/$userId'));
      
      if (response.statusCode == 200) {
        return UserProgress.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load user progress: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user progress: $e');
    }
  }

  // Generate dynamic word challenge
  Future<Challenge> generateWordChallenge(String difficulty) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/challenge/generate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'difficulty': difficulty}),
      );
      
      if (response.statusCode == 200) {
        return Challenge.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to generate challenge: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating challenge: $e');
    }
  }
}

// Models
class Challenge {
  final int id;
  final String content;
  final String type;
  final int xpReward;
  final String? ipa;
  final String? hint;
  final List<String>? options;
  final String? correctAnswer;
  final String? expectedPronunciation;

  Challenge({
    required this.id,
    required this.content,
    required this.type,
    required this.xpReward,
    this.ipa,
    this.hint,
    this.options,
    this.correctAnswer,
    this.expectedPronunciation,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      content: json['content'],
      type: json['type'],
      xpReward: json['xp_reward'],
      ipa: json['ipa'],
      hint: json['hint'],
      options: json['options'] != null 
          ? List<String>.from(json['options']) 
          : null,
      correctAnswer: json['correct_answer'],
      expectedPronunciation: json['expected_pronunciation'],
    );
  }
}

class ChallengeResult {
  final int challengeId;
  final int userId;
  final bool isCorrect;
  final int xpEarned;
  final double? accuracyScore;
  final String feedback;

  ChallengeResult({
    required this.challengeId,
    required this.userId,
    required this.isCorrect,
    required this.xpEarned,
    this.accuracyScore,
    required this.feedback,
  });

  factory ChallengeResult.fromJson(Map<String, dynamic> json) {
    return ChallengeResult(
      challengeId: json['challenge_id'],
      userId: json['user_id'],
      isCorrect: json['is_correct'],
      xpEarned: json['xp_earned'],
      accuracyScore: json['accuracy_score']?.toDouble(),
      feedback: json['feedback'],
    );
  }
}

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
}
