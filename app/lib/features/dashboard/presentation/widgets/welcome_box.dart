import '../../../../core/common/colors.dart';
import '../../../../core/common/text_styles.dart';
import 'package:flutter/material.dart';

/// ===========================================================================
/// WELCOME BACK BOX - USER WELCOME AND QUICK ACTIONS
/// ===========================================================================
///
/// PURPOSE:
/// - Welcome message for returning users
/// - Quick action buttons for common tasks
/// - Progress continuation prompts
///
/// FEATURES:
/// - Personalized welcome message
/// - Continue lesson and fast practice buttons
/// - Gradient background with border styling
/// ===========================================================================

class WelcomeBackBox extends StatelessWidget {
  final String name;
  final VoidCallback? onFastPractice;

  const WelcomeBackBox({
    super.key,
    required this.name,
    this.onFastPractice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 2),
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
          // Greeting
          Text(
            "Good to have you back, $name 👋",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 8),

          // Subtext
          Text(
            "Ready for a quick pronunciation workout?",
            style: Theme.of(context).textTheme.bodyMedium ??
                const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Quick access action
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onFastPractice,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                "Fast Practice",
                style: TextStyle(color: AppColors.primary, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}