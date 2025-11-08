import 'package:flutter/material.dart';

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

  // For API integration
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      time: json['time'] as String,
      icon: IconData(json['iconCode'] as int, fontFamily: 'MaterialIcons'),
      color: Color(json['color'] as int),
    );
  }

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
