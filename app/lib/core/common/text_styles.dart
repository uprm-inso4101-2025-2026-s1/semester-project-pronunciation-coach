import 'package:flutter/material.dart';
import 'colors.dart';

/// Centralized text style definitions for the application.
/// 
/// This class provides a consistent typography system with predefined text styles
/// for various UI elements. Using these styles ensures visual consistency
/// throughout the app and simplifies theme maintenance.
class AppTextStyles {
  // ==========================================
  // HEADERS
  // ==========================================

  /// Large white title style for welcome screens and prominent headings
  static const TextStyle welcomeTitle = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  /// Primary heading style for main page titles and important headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Secondary heading style for section titles and subheadings
  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Tertiary heading style for smaller headings and card titles
  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  // ==========================================
  // BODY TEXT
  // ==========================================

  /// Large body text for important content and prominent descriptions
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  /// Medium body text for standard content and descriptions
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  /// Small body text for secondary information and muted content
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.textMuted,
  );

  // ==========================================
  // SPECIAL TEXT STYLES
  // ==========================================

  /// Subtitle style for welcome screens with semi-transparent white text
  static TextStyle welcomeSubtitle = TextStyle(
    color: Colors.white.withValues(alpha: 0.9),
    fontSize: 16,
  );

  /// Caption style for small labels, hints, and secondary information
  static TextStyle caption = TextStyle(fontSize: 12, color: Colors.grey[600]);

  /// Large bold text for displaying progress values and important numbers
  static const TextStyle progressValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Bold text for displaying progress percentages and ratios
  static const TextStyle progressPercentage = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}
