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
          icon: Icons.menu_book,
          title: 'Lessons',
          subtitle: '12 available',
          trailing: Text(
            'Pronunciation',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        ActivityCard(
          icon: Icons.mic,
          title: 'Daily Practice',
          subtitle: '5 minutes left',
          trailing: CircleAvatar(
            radius: 14,
            backgroundColor: Colors.greenAccent,
            child: Text(
              '3/5',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ),
        ActivityCard(
          icon: Icons.flag,
          title: 'Objetivos semanales',
          subtitle: '4 of 7 days completed',
          trailing: Icon(Icons.remove, color: Colors.orange, size: 20),
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
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const ActivityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          debugPrint('$title tapped!');
        },
        splashColor: Colors.blueAccent.withValues(alpha: 0.2),
        highlightColor: Colors.blueAccent.withValues(alpha: 0.05),
        child: ListTile(
          leading: Icon(icon, size: 30, color: Colors.blueAccent),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          trailing: trailing,
        ),
      ),
    );
  }
}