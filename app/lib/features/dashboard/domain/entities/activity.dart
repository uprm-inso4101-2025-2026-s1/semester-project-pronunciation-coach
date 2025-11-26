import 'package:flutter/material.dart';

/// ===========================================================================
/// ACTIVITY ENTITY - USER ACTIVITY DATA MODEL
/// ===========================================================================
/// 
/// PURPOSE:
/// - Represents user activity data for tracking and display
/// - Supports JSON serialization/deserialization for API integration
/// - Provides consistent activity data structure across the app
/// 
/// USAGE:
/// - Track user practice sessions and achievements
/// - Display recent activity in timelines and dashboards
/// - Store and retrieve activity data from backend APIs
/// ===========================================================================

class Activity {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;

  const Activity({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });

  /// =========================================================================
  /// JSON SERIALIZATION - API INTEGRATION
  /// =========================================================================
  
  /// Creates Activity instance from JSON data for API responses
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      time: json['time'] as String,
      icon: IconData(json['iconCode'] as int, fontFamily: 'MaterialIcons'),
      color: Color(json['color'] as int),
    );
  }

  /// Converts Activity instance to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'time': time,
      'iconCode': icon.codePoint,
      'color': color.toARGB32(),
    };
  }
}