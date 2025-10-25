import 'package:flutter/material.dart';

class QuizProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const QuizProgressBar({
    super.key,
    required this.current,
    required this.total
  });

  @override
  Widget build(BuildContext context) {
    final value = current / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            color: Colors.green,
              backgroundColor: Colors.grey[300],
              minHeight: 8,
              value: value
          ),
        ),
        const SizedBox(height: 8),
        Text('Question $current of $total',
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}