import 'package:flutter/material.dart';
import '../../models/dashboard/activity.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class RecentActivityTimeline extends StatelessWidget {
  final List<Activity>? activities;

  const RecentActivityTimeline({
    Key? key,
    this.activities,
  }) : super(key: key);

  // Mock data - replace with widget.activities when available
  List<Activity> get activityList => activities ?? const [
    Activity(
      title: 'Mastered "Thought" pronunciation',
      subtitle: 'Consonant Clusters • Score: 95%',
      time: '2 hours ago',
      icon: Icons.check_circle,
      color: AppColors.success,
    ),
    Activity(
      title: 'Practiced word stress patterns',
      subtitle: 'Word Stress • 15 words completed',
      time: '4 hours ago',
      icon: Icons.mic,
      color: AppColors.primary,
    ),
    Activity(
      title: 'Improved vowel sounds',
      subtitle: 'Vowel Sounds • /æ/ sound practiced',
      time: '1 day ago',
      icon: Icons.trending_up,
      color: AppColors.warning,
    ),
    Activity(
      title: 'Daily goal achieved',
      subtitle: '10/10 words completed',
      time: '1 day ago',
      icon: Icons.emoji_events,
      color: AppColors.amber,
    ),
    Activity(
      title: 'Started intonation practice',
      subtitle: 'Intonation Patterns • Question patterns',
      time: '2 days ago',
      icon: Icons.play_circle,
      color: AppColors.purple,
    ),
  ];

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
            'Recent Practice',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activityList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final activity = activityList[index];
              return _buildActivityItem(activity);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Activity activity) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: activity.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            activity.icon,
            color: activity.color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                activity.subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Text(
          activity.time,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}