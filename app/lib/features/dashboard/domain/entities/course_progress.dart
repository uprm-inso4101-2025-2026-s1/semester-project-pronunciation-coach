import 'package:flutter/material.dart';

class CourseProgress {
  final String name;
  final double progress;
  final Color color;

  const CourseProgress(this.name, this.progress, this.color);

  // For API integration
  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      json['name'] as String,
      (json['progress'] as num).toDouble(),
      Color(json['color'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'progress': progress, 'color': color.toARGB32()};
  }
}
