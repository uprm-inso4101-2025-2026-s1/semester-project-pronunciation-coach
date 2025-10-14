import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'question_page.dart';
import '../widgets/progress_bar.dart';


class QuizResultsPage extends StatelessWidget {
  final int score;
  final int total;
  final int accuracy;
  final String quizTitle;
  final int totalQuestions;

  const QuizResultsPage({
    super.key,
    required this.score,
    required this.total,
    required this.accuracy,
    required this.totalQuestions,
    required this.quizTitle


  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Results',style: TextStyle(fontWeight: FontWeight.w600),),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding:  EdgeInsets.all(16),
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
                         Text(
                          'Your Score',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                         SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$score / $total',
                                    style:  TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                   SizedBox(height: 6),
                                  Text(
                                    'Accuracy: $accuracy%',
                                    style: TextStyle(
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
                              child: Row(
                                children:  [
                                  Icon(Icons.check_circle, size: 18),
                                  SizedBox(width: 6),
                                  Text('Completed', style: TextStyle(fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      QuizProgressBar(
                        current: score,
                        total: total,
                      ),
                        SizedBox(height: 10),
                        Text(
                          'Quiz: $quizTitle',
                          style: TextStyle(color: Colors.black.withOpacity(.6)),
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
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Back to Quiz Home'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[400],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizQuestionPage(
                            quizTitle: quizTitle,
                            totalQuestions: totalQuestions,
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
}