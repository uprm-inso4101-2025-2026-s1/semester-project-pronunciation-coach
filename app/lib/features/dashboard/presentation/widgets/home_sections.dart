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
/// - Lessons: Available pronunciation lessons
/// - Daily Practice: Current practice session progress
/// - Weekly Goals: Progress towards weekly objectives
/// ===========================================================================

class HomeSections extends StatelessWidget {
  const HomeSections({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ActivityCard(
          icon: Icons.mic,
          title: 'Daily Practice',
          subtitle: '5 questions left',
          trailing: CircleAvatar(
            radius: 14,
            backgroundColor: Colors.greenAccent,
            child: Text(
              '0/5',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ),
        SizedBox(height: 12),
        ActivityCard(
          icon: Icons.flag,
          title: 'Weekly Objectives',
          subtitle: '35 questions left',
          trailing: CircleAvatar(
            radius: 14,
            backgroundColor: Colors.greenAccent,
            child: Text(
              '0/35',
              style: TextStyle(fontSize: 12, color: Colors.black87),
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

  const ActivityCard({
    super.key,
    required this.leadingIcon,
    required this.titleText,
    required this.subtitleText,
    required this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        // Currently just visual, not a button that navigates anywhere
        onTap: () {
          debugPrint('$title tapped!');
        },
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
