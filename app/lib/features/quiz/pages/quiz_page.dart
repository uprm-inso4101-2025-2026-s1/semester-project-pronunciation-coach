import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../widgets/quiz_card.dart';
import 'question_page.dart';

class QuizHomePage extends StatelessWidget {
  const QuizHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Daily Quizzes',style: TextStyle(fontWeight: FontWeight.w600),),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          Text('Pronunciation Quizzes',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          // Sample quizzes
          QuizCard(
            title: 'Vowel Sounds',
            subtitle: 'Short vs long vowel practice',
            questionCount: 10,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const QuizQuestionPage(
                    quizTitle: 'Vowel Sounds',
                    totalQuestions: 10,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          QuizCard(
            title: 'Word Stress',
            subtitle: 'Primary & secondary stress',
            questionCount: 8,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const QuizQuestionPage(
                    quizTitle: 'Word Stress',
                    totalQuestions: 8,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          QuizCard(
            title: 'Pronounciation Patterns',
            subtitle: 'Risisng & Falling tones practice',
            questionCount: 9,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const QuizQuestionPage(
                    quizTitle: 'Pronounciation Patterns',
                    totalQuestions: 9,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          QuizCard(
            title: 'Ending Sounds',
            subtitle: 'Practice final consonant pronunciation',
            questionCount: 6,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const QuizQuestionPage(
                    quizTitle: 'Ending Sounds',
                    totalQuestions: 6,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}