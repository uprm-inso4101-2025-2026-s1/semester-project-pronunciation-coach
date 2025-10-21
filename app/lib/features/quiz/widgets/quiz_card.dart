import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class QuizCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int questionCount;
  final VoidCallback onTap;

  const QuizCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.questionCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.record_voice_over_rounded),
              ),
               SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                     SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(color: Colors.black.withOpacity(.6))),
                  ],
                ),
              ),
              Text('${questionCount} Q',
                  style:  TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}