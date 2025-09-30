import 'package:app/core/constants/colors.dart';
import 'package:app/core/constants/text_styles.dart';
import 'package:flutter/material.dart';

class UserInfoBox extends StatelessWidget {
  final String name;
  final String avatarURL;
  final String proficiencyLevel;

  const UserInfoBox({
    super.key,
    required this.name,
    required this.avatarURL,
    required this.proficiencyLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('test'),
        ],
      ),      
    );
  }
}
