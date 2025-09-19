import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../models/course_progress.dart';

class ProgressVisualizationWidget extends StatefulWidget {
  final List<CourseProgress>? courses;

  const ProgressVisualizationWidget({
    super.key,
    this.courses,
  });

  @override
  State<ProgressVisualizationWidget> createState() => _ProgressVisualizationWidgetState();
}

class _ProgressVisualizationWidgetState extends State<ProgressVisualizationWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  // Mock data - replace with widget.courses when available
  List<CourseProgress> get courses => widget.courses ?? [
    const CourseProgress('Vowel Sounds', 0.92, AppColors.success),
    const CourseProgress('Consonant Clusters', 0.78, AppColors.primary),
    const CourseProgress('Word Stress', 0.65, AppColors.warning),
    const CourseProgress('Intonation Patterns', 0.45, AppColors.purple),
    const CourseProgress('Connected Speech', 0.30, Color(0xFFEF4444)),
  ];

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressAnimationController, curve: Curves.easeInOut),
    );
    _progressAnimationController.forward();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pronunciation Skills',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 20),
          ...courses.map((course) => _buildProgressBar(course)),
        ],
      ),
    );
  }

  Widget _buildProgressBar(CourseProgress course) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                course.name,
                style: AppTextStyles.bodyLarge,
              ),
              Text(
                '${(course.progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: course.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: course.progress * _progressAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [course.color, course.color.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}