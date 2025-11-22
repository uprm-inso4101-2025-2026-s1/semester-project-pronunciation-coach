import 'package:flutter/material.dart';

/// A centralized color scheme for the application.
/// 
/// This class contains all color constants used throughout the app,
/// ensuring consistency and easy maintenance of the design system.
/// All colors are defined as static constants for easy access.
class AppColors {
  // ==========================================
  // BRAND COLORS
  // ==========================================
  
  /// Primary brand color - used for main buttons, active states, and key UI elements
  static const Color primary = Color(0xFF3B82F6);
  
  /// Secondary brand color - used for secondary buttons and accents
  static const Color secondary = Color(0xFF1D4ED8);
  
  /// Purple accent color - used for special highlights and alternate accents
  static const Color purple = Color(0xFF8B5CF6);
  
  /// Orange color from Material Design palette
  static const Color orange = Colors.orange;
  
  /// Amber color from Material Design palette
  static const Color amber = Colors.amber;

  // ==========================================
  // SEMANTIC COLORS
  // ==========================================
  
  /// Success color - indicates positive actions, success states, or completion
  static const Color success = Color(0xFF10B981);
  
  /// Warning color - indicates caution, warnings, or pending states
  static const Color warning = Color(0xFFF59E0B);
  
  /// Danger color - indicates errors, destructive actions, or critical alerts
  static const Color danger = Color(0xFFEF4444);

  // ==========================================
  // BACKGROUND COLORS
  // ==========================================
  
  /// Main application background color
  static const Color background = Color(0xFFF8FAFC);
  
  /// Background color for cards, dialogs, and elevated surfaces
  static const Color cardBackground = Colors.white;

  // ==========================================
  // TEXT COLORS
  // ==========================================
  
  /// Primary text color for most content and headings
  static const Color textPrimary = Color(0xFF1E293B);
  
  /// Secondary text color for less important text
  static const Color textSecondary = Color(0xFF374151);
  
  /// Muted text color for disabled states, hints, and placeholder text
  static const Color textMuted = Color(0xFF6B7280);

  // ==========================================
  // EFFECT COLORS
  // ==========================================
  
  /// Shadow color for cards and elevated elements (5% opacity black)
  static Color cardShadow = Colors.black.withValues(alpha: 0.05);
}