import 'package:flutter/material.dart';

/// ===========================================================================
/// HOME SECTIONS - MAIN HOME PAGE CONTENT SECTIONS
/// ===========================================================================
///
/// PURPOSE:
/// - Provides structured content sections for the home page
/// - Displays quick access activities and progress indicators
/// - Implements consistent card-based layout
///
/// SECTIONS:
/// - Daily Practice: Current practice session progress
/// - Weekly Objectives: Progress towards weekly lesson goals
/// ===========================================================================
class HomeSections extends StatelessWidget {
  final int dailyLessonsCompleted;
  final int dailyGoal;
  final int weeklyLessonsCompleted;
  final int weeklyGoal;

  const HomeSections({
    super.key,
    required this.dailyLessonsCompleted,
    required this.dailyGoal,
    required this.weeklyLessonsCompleted,
    required this.weeklyGoal,
  });

  @override
  Widget build(BuildContext context) {
    // Clamp values to avoid negative or overflown counters
    final int safeDailyCompleted =
        dailyLessonsCompleted < 0
            ? 0
            : (dailyLessonsCompleted > dailyGoal
                ? dailyGoal
                : dailyLessonsCompleted);

    final int safeWeeklyCompleted =
        weeklyLessonsCompleted < 0
            ? 0
            : (weeklyLessonsCompleted > weeklyGoal
                ? weeklyGoal
                : weeklyLessonsCompleted);

    final int dailyRemaining = dailyGoal - safeDailyCompleted;
    final int weeklyRemaining = weeklyGoal - safeWeeklyCompleted;

    return Column(
      children: [
        ActivityCard(
          leadingIcon: Icons.mic,
          titleText: 'Daily Practice',
          subtitleText: dailyRemaining > 0
              ? '$dailyRemaining practice lessons left today'
              : 'Daily goal completed 🎉',
          trailingWidget: CircleAvatar(
            radius: 14,
            backgroundColor: Colors.greenAccent,
            child: Text(
              '$safeDailyCompleted/$dailyGoal',
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ActivityCard(
          leadingIcon: Icons.flag,
          titleText: 'Weekly Objectives',
          subtitleText: weeklyRemaining > 0
          ? '$safeWeeklyCompleted of $weeklyGoal lessons done this week'
          : 'Weekly goal completed 🎉 ($safeWeeklyCompleted/$weeklyGoal)',
          trailingWidget: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.greenAccent,
            child: Text(
              '$safeWeeklyCompleted',
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}

/// ===========================================================================
/// ACTIVITY CARD - REUSABLE ACTIVITY DISPLAY CARD
/// ===========================================================================
///
/// PURPOSE:
/// - Consistent card layout for activity items
/// - Interactive tap feedback with ripple effects
/// - Flexible content arrangement with icon, text, and trailing widget
///
/// FEATURES:
/// - Customizable icon, title, subtitle, and trailing content
/// - Smooth tap animations and visual feedback
/// - Consistent styling with rounded corners and shadows
/// ===========================================================================
class ActivityCard extends StatelessWidget {
  final IconData leadingIcon;
  final String titleText;
  final String subtitleText;
  final Widget trailingWidget;
  final VoidCallback? onTap;

  const ActivityCard({
    super.key,
    required this.leadingIcon,
    required this.titleText,
    required this.subtitleText,
    required this.trailingWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: Colors.blueAccent.withValues(alpha: 0.2),
        highlightColor: Colors.blueAccent.withValues(alpha: 0.05),
        child: ListTile(
          leading: Icon(leadingIcon, size: 30, color: Colors.blueAccent),
          title: Text(
            titleText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitleText),
          trailing: trailingWidget,
        ),
      ),
    );
  }
}
