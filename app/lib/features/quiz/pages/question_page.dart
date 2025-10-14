import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../widgets/progress_bar.dart';
import '../widgets/option_card.dart';
import 'result_page.dart';

class QuizQuestionPage extends StatefulWidget {
  final String quizTitle;
  final int totalQuestions;
  const QuizQuestionPage({
    super.key,
    required this.quizTitle,
    required this.totalQuestions,
  });

  @override
  State<QuizQuestionPage> createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage> {
  int current_question = 1;
  int? selected;

  // placeholder options
  final List<String> options = const ['Option A', 'Option B', 'Option C', 'Option D'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.quizTitle,style: TextStyle(fontWeight: FontWeight.w600),),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuizProgressBar(current: current_question, total: widget.totalQuestions),
            const SizedBox(height: 16),

            // Question Placeholder
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: const Text(
                'Placeholder question added later',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),

            // Options Placeholder
            Expanded(
              child: ListView.separated(
                itemCount: options.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) => OptionCard(
                  option: options[i],
                  selected: selected == i,
                  onTap: () => setState(() => selected = i),
                ),
              ),
            ),

            // Feedback placeholder
            Text(selected == null ? 'Select an option to continue.'
                  : 'Feedback placeholder (correct/try again).',
              style: TextStyle(color: Colors.black),
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
                        if (current_question > 1) {
                          setState(() {
                            current_question--;
                            selected = null;
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
                    backgroundColor: selected == null ? Colors.grey[400] : Colors.green[400],
                    foregroundColor: Colors.white,
                      ),
                    onPressed:
                    // UI only
                    selected == null ? null : () {
                      if(current_question < widget.totalQuestions) {
                        setState(() {
                          current_question++;
                          selected = null;
                        });
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>  QuizResultsPage(
                              score: 7,                // placeholder
                              total: widget.totalQuestions,
                              accuracy: 70,            // placeholder
                              quizTitle: widget.quizTitle,
                              totalQuestions: widget.totalQuestions,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(current_question < widget.totalQuestions ? 'Submit' : 'Finish Quiz'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}