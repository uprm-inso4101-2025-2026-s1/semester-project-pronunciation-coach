import 'package:flutter/material.dart';

/// ===========================================================================
/// COURSE PROGRESS ENTITY - LEARNING PROGRESS DATA MODEL
/// ===========================================================================
/// 
/// PURPOSE:
/// - Tracks user progress in individual courses or skills
/// - Provides progress visualization data for charts and graphs
/// - Supports JSON serialization for persistent storage
/// 
/// USAGE:
/// - Display progress bars in dashboard
/// - Track completion rates for courses
/// - Visualize skill development over time
/// ===========================================================================

class CourseProgress {
  final String name;
  final double progress;
  final Color color;

  const CourseProgress(this.name, this.progress, this.color);

  /// =========================================================================
  /// JSON SERIALIZATION - API INTEGRATION
  /// =========================================================================
  
  /// Creates CourseProgress instance from JSON data
  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      json['name'] as String,
      (json['progress'] as num).toDouble(),
      Color(json['color'] as int),
    );
  }

  /// Converts CourseProgress instance to JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'progress': progress, 'color': color.toARGB32()};
  }
}