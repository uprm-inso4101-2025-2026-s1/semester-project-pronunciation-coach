import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/api_service.dart';
import '../widgets/progress_bar.dart';
import '../widgets/option_card.dart';
import 'result_page.dart';

class QuizQuestionPage extends StatefulWidget {
  final List<Challenge> challenges;
  
  const QuizQuestionPage({
    super.key,
    required this.challenges,
  });

  @override
  State<QuizQuestionPage> createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage> {
  final ApiService _apiService = ApiService();
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;
  List<ChallengeResult> _results = [];
  bool _isSubmitting = false;
  String? _feedback;
  bool _hasAnswered = false;
  final int _userId = 1; // Default user ID, replace with actual user management

  Challenge get _currentChallenge => widget.challenges[_currentQuestionIndex];
  
  int get _correctAnswers => _results.where((r) => r.isCorrect).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Quiz Challenge',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuizProgressBar(
              current: _currentQuestionIndex + 1,
              total: widget.challenges.length,
            ),
            const SizedBox(height: 16),

            // Question Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentChallenge.content,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_currentChallenge.hint != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb_outline,
                              size: 16, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _currentChallenge.hint!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'XP Reward: ${_currentChallenge.xpReward}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Options
            if (_currentChallenge.options != null)
              Expanded(
                child: ListView.separated(
                  itemCount: _currentChallenge.options!.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final option = _currentChallenge.options![i];
                    final optionLetter = String.fromCharCode(65 + i); // A, B, C, D
                    
                    return OptionCard(
                      option: '$optionLetter. $option',
                      selected: _selectedOptionIndex == i,
                      onTap: _hasAnswered ? null : () {
                        setState(() {
                          _selectedOptionIndex = i;
                          _feedback = null;
                        });
                      },
                    );
                  },
                ),
              ),

            // Feedback
            if (_feedback != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _hasAnswered && _results.last.isCorrect
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _hasAnswered && _results.last.isCorrect
                          ? Icons.check_circle
                          : Icons.info,
                      color: _hasAnswered && _results.last.isCorrect
                          ? Colors.green
                          : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _feedback!,
                        style: TextStyle(
                          color: _hasAnswered && _results.last.isCorrect
                              ? Colors.green[700]
                              : Colors.orange[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Text(
                _selectedOptionIndex == null
                    ? 'Select an option to continue.'
                    : 'Tap Submit to check your answer.',
                style: const TextStyle(color: Colors.black),
              ),
            const SizedBox(height: 12),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_currentQuestionIndex > 0 && !_hasAnswered) {
                        setState(() {
                          _currentQuestionIndex--;
                          _selectedOptionIndex = null;
                          _feedback = null;
                          _hasAnswered = false;
                        });
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Return'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedOptionIndex == null
                          ? Colors.grey[400]
                          : _hasAnswered
                              ? Colors.blue[400]
                              : Colors.green[400],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _selectedOptionIndex == null || _isSubmitting
                        ? null
                        : _hasAnswered
                            ? _goToNextQuestion
                            : _submitAnswer,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _hasAnswered
                                ? (_currentQuestionIndex < widget.challenges.length - 1
                                    ? 'Next'
                                    : 'Finish')
                                : 'Submit',
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitAnswer() async {
    if (_selectedOptionIndex == null || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final selectedLetter = String.fromCharCode(65 + _selectedOptionIndex!);
      final result = await _apiService.submitMultipleChoiceAnswer(
        _currentChallenge.id,
        selectedLetter,
        _userId,
      );

      setState(() {
        _results.add(result);
        _feedback = result.feedback;
        _hasAnswered = true;
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting answer: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex < widget.challenges.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
        _feedback = null;
        _hasAnswered = false;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    final totalXp = _results.fold<int>(0, (sum, result) => sum + result.xpEarned);
    final accuracy = (_correctAnswers / widget.challenges.length * 100).round();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultsPage(
          score: _correctAnswers,
          total: widget.challenges.length,
          accuracy: accuracy,
          totalXp: totalXp,
          challenges: widget.challenges,
        ),
      ),
    );
  }
}
