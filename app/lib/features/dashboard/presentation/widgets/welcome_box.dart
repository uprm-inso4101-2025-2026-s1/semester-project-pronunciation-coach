import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/common/text_styles.dart';

/// ===========================================================================
/// WELCOME BACK BOX - USER WELCOME AND QUICK ACTIONS
/// ===========================================================================
///
/// PURPOSE:
/// - Welcome message for returning users
/// - Quick action button for Fast Practice
///
/// FEATURES:
/// - Personalized welcome message
/// - Single Fast Practice button (no Continue Lesson)
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
            "Hit Fast Practice to jump into a quick pronunciation quiz.",
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),

          // Fast Practice button ONLY
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              onPressed: onFastPractice ??
                  () {
                    // Fallback if no callback is wired
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Fast Practice is not connected yet. Please try again later.',
                        ),
                      ),
                    );
                  },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 1.4.h,
                  horizontal: 30.5.w,
                ),
              ),
              child: const Text(
                "Fast Practice",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
