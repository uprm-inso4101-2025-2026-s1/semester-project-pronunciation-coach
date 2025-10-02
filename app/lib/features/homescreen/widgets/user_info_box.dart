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
    final screenWidth = MediaQuery.of(context).size.width;

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
          // Avatar and Name
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(avatarURL),
                radius: screenWidth * 0.03,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    name,
                    style: AppTextStyles.heading2,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Proficiency level
          Row(
            children: [
              SizedBox(width: screenWidth * 0.10),
              Expanded(
                child: Text(
                  proficiencyLevel,
                  style: AppTextStyles.heading3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),
          // Stats
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,          
                children: [
                  _buildStatBox(Icons.calendar_month, "15", "Active Days"),
                  _buildStatBox(Icons.arrow_outward_rounded, "92%", "Precision"),
                ],
              );
            },
          ),
        ],
      ),      
    );
  }

    Widget _buildStatBox(IconData icon, String value, String label) {
      return Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      );
    }
}
