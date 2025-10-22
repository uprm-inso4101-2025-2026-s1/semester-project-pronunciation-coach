import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/api_service.dart';
import 'question_page.dart';
import '../widgets/progress_bar.dart';

class QuizResultsPage extends StatelessWidget {
  final int score;
  final int total;
  final int accuracy;
  final int totalXp;
  final List<Challenge> challenges;

  const QuizResultsPage({
    super.key,
    required this.score,
    required this.total,
    required this.accuracy,
    required this.totalXp,
    required this.challenges,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Results',
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quiz Complete!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Score Section
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Your Score',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '$score / $total',
                                    style: const TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Accuracy: $accuracy%',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.check_circle, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'Completed',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Progress Bar
                        QuizProgressBar(
                          current: score,
                          total: total,
                        ),
                        const SizedBox(height: 20),
                        
                        // XP Earned
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.withOpacity(0.2),
                                Colors.orange.withOpacity(0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.stars,
                                color: Colors.amber,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'XP Earned',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '$totalXp XP',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Performance Message
                        Text(
                          _getPerformanceMessage(accuracy),
                          style: TextStyle(
                            color: Colors.black.withOpacity(.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Back to Home'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizQuestionPage(
                            challenges: challenges,
                          ),
                        ),
                      );
                    },
                    child: const Text('Retry Quiz'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _getPerformanceMessage(int accuracy) {
    if (accuracy >= 90) {
      return '🎉 Outstanding! You have excellent pronunciation knowledge!';
    } else if (accuracy >= 75) {
      return '🌟 Great job! Keep up the good work!';
    } else if (accuracy >= 60) {
      return '👍 Good effort! Practice makes perfect!';
    } else {
      return '💪 Keep practicing! You\'ll improve with time!';
    }
  }
}
