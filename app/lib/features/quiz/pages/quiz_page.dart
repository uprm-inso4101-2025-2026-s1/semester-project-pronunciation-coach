import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/api_service.dart';
import '../widgets/quiz_card.dart';
import 'question_page.dart';

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  final ApiService _apiService = ApiService();
  List<Challenge>? _challenges;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadChallenges();
  }

  Future<void> _loadChallenges() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final challenges = await _apiService.getChallenges();
      setState(() {
        _challenges = challenges;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Daily Quizzes',
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadChallenges,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading challenges',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadChallenges,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : _challenges == null || _challenges!.isEmpty
                  ? const Center(
                      child: Text('No challenges available'),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'Pronunciation Challenges',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._buildChallengeCards(),
                      ],
                    ),
    );
  }

  List<Widget> _buildChallengeCards() {
    final multipleChoiceChallenges = _challenges!
        .where((c) => c.type == 'multiple_choice')
        .toList();

    return multipleChoiceChallenges.map((challenge) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: QuizCard(
          title: _getQuizTitle(challenge),
          subtitle: challenge.hint ?? 'Test your pronunciation knowledge',
          questionCount: 1, // Each challenge is one question
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QuizQuestionPage(
                  challenges: [challenge],
                ),
              ),
            );
          },
        ),
      );
    }).toList();
  }

  String _getQuizTitle(Challenge challenge) {
    if (challenge.content.contains('thorough')) {
      return 'Thorough Pronunciation';
    } else if (challenge.content.contains('silent')) {
      return 'Silent Letters';
    } else if (challenge.id >= 1000) {
      return 'Spelling Challenge';
    }
    return 'Challenge #${challenge.id}';
  }
}
