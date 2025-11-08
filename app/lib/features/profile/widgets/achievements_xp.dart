import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../core/constants/colors.dart';

class Achievement {
  final String id;
  final String groupId;
  final String title;
  final String description;
  final IconData icon;
  int currentProgress;
  final int totalRequired;
  bool isUnlocked;
  DateTime? unlockedDate;

  Achievement({
    required this.id,
    required this.groupId,
    required this.title,
    required this.description,
    required this.icon,
    required this.currentProgress,
    required this.totalRequired,
    required this.isUnlocked,
    this.unlockedDate,
  });

  double get progress => currentProgress / totalRequired;

  Map<String, dynamic> toJson() => {
    'id': id,
    'groupId': groupId,
    'title': title,
    'description': description,
    'icon': icon.codePoint,
    'currentProgress': currentProgress,
    'totalRequired': totalRequired,
    'isUnlocked': isUnlocked,
    'unlockedDate': unlockedDate?.toIso8601String(),
  };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
    id: json['id'],
    groupId: json['groupId'],
    title: json['title'],
    description: json['description'],
    icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
    currentProgress: json['currentProgress'],
    totalRequired: json['totalRequired'],
    isUnlocked: json['isUnlocked'],
    unlockedDate: json['unlockedDate'] != null
        ? DateTime.parse(json['unlockedDate'])
        : null,
  );
}

class AchievementsSection extends StatefulWidget {
  const AchievementsSection({super.key});

  @override
  State<AchievementsSection> createState() => _AchievementsSectionState();
}

class _AchievementsSectionState extends State<AchievementsSection> {
  int totalXP = 0;
  int currentStreak = 0;
  List<Achievement> achievements = [];
  Map<String, bool> expandedGroups = {}; // To track which groups are expanded

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    // Load stored achievements
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('achievements');

    if (data != null) {
      final decoded = jsonDecode(data) as List;
      achievements = decoded.map((e) => Achievement.fromJson(e)).toList();
    } else {
      achievements = _defaultAchievements();
    }

    // Set default progress values since daily challenge is removed
    totalXP = 4200; // Default XP
    currentStreak = 3; // Default streak

    // Update achievement progress according to default values
    for (var a in achievements) {
      if (a.groupId == 'xp') {
        a.currentProgress = totalXP;
      } else if (a.groupId == 'streak') {
        a.currentProgress = currentStreak;
      }

      // Automatically unlock if progress is enough
      if (!a.isUnlocked && a.currentProgress >= a.totalRequired) {
        a.isUnlocked = true;
        a.unlockedDate = DateTime.now();
      }
    }

    await _saveAchievements();

    setState(() {});
  }

  Future<void> _saveAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'achievements',
      jsonEncode(achievements.map((a) => a.toJson()).toList()),
    );
  }

  List<Achievement> _defaultAchievements() {
    return [
      // Streak Achievements
      Achievement(
        id: 'streak1',
        groupId: 'streak',
        title: 'NewsLetter',
        description: 'Get a 1-day streak from daily challenge.',
        icon: Icons.local_fire_department,
        currentProgress: 3,
        totalRequired: 1,
        isUnlocked: false,
      ),
      Achievement(
        id: 'streak7',
        groupId: 'streak',
        title: 'Weekly Wordsmith',
        description: 'Get a 7-day from daily challenge.',
        icon: Icons.local_fire_department,
        currentProgress: 3,
        totalRequired: 7,
        isUnlocked: false,
      ),
      Achievement(
        id: 'streak30',
        groupId: 'streak',
        title: 'Articulate Apprentice',
        description: 'Get a 30-day streak from daily challenge.',
        icon: Icons.local_fire_department,
        currentProgress: 0,
        totalRequired: 30,
        isUnlocked: false,
      ),
      Achievement(
        id: 'streak100',
        groupId: 'streak',
        title: 'Phonetic Centurion',
        description: 'Get a 100-day streak from daily challenge.',
        icon: Icons.local_fire_department,
        currentProgress: 0,
        totalRequired: 100,
        isUnlocked: false,
      ),
      Achievement(
        id: 'streak250',
        groupId: 'streak',
        title: 'Vocal Virtuoso',
        description: 'Get a 250-day streak from daily challenge.',
        icon: Icons.local_fire_department,
        currentProgress: 0,
        totalRequired: 250,
        isUnlocked: false,
      ),
      Achievement(
        id: 'streak500',
        groupId: 'streak',
        title: 'Speech Legend',
        description: 'Get a 500-day streak from daily challenge.',
        icon: Icons.local_fire_department,
        currentProgress: 0,
        totalRequired: 500,
        isUnlocked: false,
      ),

      // XP Achievements
      Achievement(
        id: 'xp1k',
        groupId: 'xp',
        title: 'First Steps',
        description: 'Reach 1,000 XP points total.',
        icon: Icons.star,
        currentProgress: 800,
        totalRequired: 1000,
        isUnlocked: false,
      ),
      Achievement(
        id: 'xp10k',
        groupId: 'xp',
        title: 'Rising Star',
        description: 'Reach 10,000 XP points total.',
        icon: Icons.star_half_outlined,
        currentProgress: 4200,
        totalRequired: 10000,
        isUnlocked: false,
      ),
      Achievement(
        id: 'xp25k',
        groupId: 'xp',
        title: 'Dedicated Learner',
        description: 'Reach 25,000 XP points total.',
        icon: Icons.star_rate_outlined,
        currentProgress: 4200,
        totalRequired: 25000,
        isUnlocked: false,
      ),
      Achievement(
        id: 'xp75k',
        groupId: 'xp',
        title: 'Seasoned Veteran',
        description: 'Reach 75,000 XP points total.',
        icon: Icons.stars_outlined,
        currentProgress: 4200,
        totalRequired: 75000,
        isUnlocked: false,
      ),
      Achievement(
        id: 'xp200k',
        groupId: 'xp',
        title: 'Ultimate Champion',
        description: 'Reach 200,000 XP points total.',
        icon: Icons.workspace_premium,
        currentProgress: 4200,
        totalRequired: 200000,
        isUnlocked: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Achievement>> grouped = {};
    for (var a in achievements) {
      grouped.putIfAbsent(a.groupId, () => []).add(a);
    }

    final completed = achievements.where((a) => a.isUnlocked).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Achievements',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        // XP and Streak summary
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total XP',
                '$totalXP XP',
                Icons.trending_up,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Current Streak',
                '$currentStreak Days',
                Icons.local_fire_department,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Grouped Achievements
        ...grouped.entries.map(
          (entry) => _buildAchievementGroup(entry.key, entry.value),
        ),

        // Completed Achievements
        if (completed.isNotEmpty) ...[
          const SizedBox(height: 30),
          const Text(
            'Completed',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...completed.map(_buildCompletedAchievementCard),
        ],
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementGroup(String groupId, List<Achievement> group) {
    final isExpanded = expandedGroups[groupId] ?? false;

    final topAchievement = group.firstWhere(
      (a) => !a.isUnlocked,
      orElse: () => group.last,
    );

    final restAchievements = group
        .where((a) => a != topAchievement && !a.isUnlocked)
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                expandedGroups[groupId] = !isExpanded;
              });
            },
            child: Stack(
              children: [
                _buildAchievementCard(
                  topAchievement,
                  isTopOfGroup: true,
                  group: group,
                ),
                if (!isExpanded && group.any((a) => !a.isUnlocked))
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.2),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (isExpanded)
            Column(
              children: restAchievements.map(_buildAchievementCard).toList(),
            ),
        ],
      ),
    );
  }

  // Modified achievement card
  Widget _buildAchievementCard(
    Achievement a, {
    bool isTopOfGroup = false,
    List<Achievement>? group,
  }) {
    bool locked = !a.isUnlocked && a.currentProgress < a.totalRequired;

    // If this is the first locked achievement in its group, unlock visually
    if (isTopOfGroup && group != null) {
      final firstLockedIndex = group.indexWhere((ach) => !ach.isUnlocked);
      if (firstLockedIndex != -1 && group[firstLockedIndex].id == a.id) {
        locked = false; // visually unlock
      }
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: locked ? 0.6 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              a.icon,
              color: locked
                  ? Colors.grey
                  : (a.groupId == 'streak' ? Colors.orange : Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: locked ? Colors.grey : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    a.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: a.progress.clamp(0, 1),
                    backgroundColor: Colors.grey[300],
                    color: locked ? Colors.grey : Colors.blue,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    a.isUnlocked
                        ? 'Completed on ${a.unlockedDate?.toLocal()}'
                        : '${a.currentProgress}/${a.totalRequired}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            if (locked)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.lock, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedAchievementCard(Achievement a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.greenAccent),
      ),
      child: Row(
        children: [
          Icon(a.icon, color: Colors.green),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Completed on ${a.unlockedDate?.toLocal().toString().split(".").first}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
