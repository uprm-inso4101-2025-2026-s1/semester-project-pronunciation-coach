import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  // Headers
  static const TextStyle welcomeTitle = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.textMuted,
  );

  // Special text styles
  static TextStyle welcomeSubtitle = TextStyle(
    color: Colors.white.withOpacity(0.9),
    fontSize: 16,
  );

  static TextStyle caption = TextStyle(
    fontSize: 12,
    color: Colors.grey[600],
  );

  static const TextStyle progressValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle progressPercentage = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}