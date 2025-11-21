import 'package:flutter/material.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/quiz_attempt.dart';

class InsightStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const InsightStat({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              color: color.withValues(alpha: 0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class HighlightCard extends StatelessWidget {
  final String title;
  final QuizAttempt attempt;
  final IconData icon;
  final Color color;

  const HighlightCard({
    super.key,
    required this.title,
    required this.attempt,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formatHistoryDate(attempt.createdAt),
            style: TextStyle(color: color.withValues(alpha: 0.9), fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            attempt.isCorrect ? 'Great pronunciation!' : 'Keep practicing',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${capitalizeDifficulty(attempt.difficulty)} • ${attempt.xpEarned} XP',
            style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

Color difficultyColor(String difficulty) {
  switch (difficulty.toLowerCase()) {
    case 'easy':
      return Colors.green;
    case 'medium':
      return Colors.orange;
    case 'hard':
      return Colors.red;
    default:
      return AppColors.secondary;
  }
}

String capitalizeDifficulty(String difficulty) {
  if (difficulty.isEmpty) return difficulty;
  return difficulty[0].toUpperCase() + difficulty.substring(1).toLowerCase();
}

String formatHistoryDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final month = months[date.month - 1];
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final minute = date.minute.toString().padLeft(2, '0');
  final suffix = date.hour >= 12 ? 'PM' : 'AM';
  return '$month ${date.day}, ${date.year} · $hour:$minute $suffix';
}
