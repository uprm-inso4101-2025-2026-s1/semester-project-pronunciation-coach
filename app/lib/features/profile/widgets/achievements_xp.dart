import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../core/common/colors.dart';
import '../../../../core/common/user_progress.dart';

/// ===========================================================================
/// ACHIEVEMENT ENTITY - ACHIEVEMENT DATA MODEL
/// ===========================================================================
/// 
/// PURPOSE:
/// - Represents individual user achievements with progress tracking
/// - Supports JSON serialization for persistent storage
/// - Manages achievement states (locked/unlocked) and progress
/// 
/// PROPERTIES:
/// - id: Unique identifier for the achievement
/// - groupId: Category grouping (xp, streak, etc.)
/// - title: Achievement display name
/// - description: Detailed achievement description
/// - icon: Visual representation icon
/// - currentProgress: User's current progress towards completion
/// - totalRequired: Total required for achievement completion
/// - isUnlocked: Achievement completion status
/// - unlockedDate: Timestamp when achievement was unlocked
/// ===========================================================================

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

  /// Calculate progress percentage (0.0 to 1.0)
  double get progress => currentProgress / totalRequired;

  /// Convert achievement to JSON for storage
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

  /// Create achievement from JSON data
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

/// ===========================================================================
/// ACHIEVEMENTS SECTION - ACHIEVEMENT DISPLAY AND MANAGEMENT
/// ===========================================================================
/// 
/// PURPOSE:
/// - Main widget for displaying and managing user achievements
/// - Integrates with UserProgress for real-time data
/// - Provides expandable achievement groups and progress tracking
/// - Handles achievement unlocking and persistence
/// 
/// FEATURES:
/// - Grouped achievement display with expand/collapse
/// - Progress visualization with linear progress bars
/// - XP and streak summary cards
/// - Completed achievements section
/// - Persistent storage using SharedPreferences
/// ===========================================================================

class AchievementsSection extends StatefulWidget {
  final UserProgress userProgress;

  const AchievementsSection({
    super.key,
    required this.userProgress, // Real user progress data
  });

  @override
  State<AchievementsSection> createState() => _AchievementsSectionState();
}

class _AchievementsSectionState extends State<AchievementsSection> {
  int totalXP = 0;
  int currentStreak = 0;
  List<Achievement> achievements = [];
  
  /// Track which achievement groups are expanded
  Map<String, bool> expandedGroups = {};

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  /// Load user profile data and achievements
  Future<void> _loadProfileData() async {
    // Load stored achievements from persistent storage
    final prefs = await SharedPreferences.getInstance();
    final userId = widget.userProgress.userId;
    final data = prefs.getString('achievements_$userId');

    if (data != null) {
      final decoded = jsonDecode(data) as List;
      achievements = decoded.map((e) => Achievement.fromJson(e)).toList();
    } else {
      // Initialize with default achievements if none exist
      achievements = _defaultAchievements();
    }

    // Use real data from userProgress
    totalXP = widget.userProgress.totalXp;
    currentStreak = widget.userProgress.currentStreak;

    // Update achievement progress based on user data
    for (var a in achievements) {
      if (a.groupId == 'xp') {
        a.currentProgress = totalXP;
      } else if (a.groupId == 'streak') {
        a.currentProgress = currentStreak;
      }

      // Automatically unlock if progress requirements are met
      if (!a.isUnlocked && a.currentProgress >= a.totalRequired) {
        a.isUnlocked = true;
        a.unlockedDate = DateTime.now();
      }
    }

    await _saveAchievements();
    setState(() {});
  }

  /// Save achievements to persistent storage
  Future<void> _saveAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'achievements',
      jsonEncode(achievements.map((a) => a.toJson()).toList()),
    );
  }

  /// Define default achievement structure
  List<Achievement> _defaultAchievements() {
    return [
      // =======================================================================
      // STREAK ACHIEVEMENTS - Consecutive correct answers
      // =======================================================================
      Achievement(
        id: 'streak3',
        groupId: 'streak',
        title: 'First Spark',
        description: 'Get 3 correct answers in a row!',
        icon: Icons.local_fire_department,
        currentProgress: 0,
        totalRequired: 3,
        isUnlocked: false,
      ),
      Achievement(
        id: 'streak10',
        groupId: 'streak',
        title: 'Articulate Apprentice',
        description: 'Nail 10 correct answers in a row!',
        icon: Icons.local_fire_department,
        currentProgress: 0,
        totalRequired: 10,
        isUnlocked: false,
      ),
      Achievement(
        id: 'streak25',
        groupId: 'streak',
        title: 'Quiz Enthusiast',
        description: 'Achieve 25 correct answers in a row!',
        icon: Icons.local_fire_department,
        currentProgress: 0,
        totalRequired: 25,
        isUnlocked: false,
      ),
      Achievement(
        id: 'streak50',
        groupId: 'streak',
        title: 'Vocal Virtuoso',
        description: 'Master 50 correct answers in a row!',
        icon: Icons.local_fire_department,
        currentProgress: 0,
        totalRequired: 50,
        isUnlocked: false,
      ),
      Achievement(
        id: 'streak100',
        groupId: 'streak',
        title: 'Speech Legend',
        description: 'A legendary 100 correct answers in a row!',
        icon: Icons.local_fire_department,
        currentProgress: 0,
        totalRequired: 100,
        isUnlocked: false,
      ),

      // =======================================================================
      // XP ACHIEVEMENTS - Total experience points milestones
      // =======================================================================
      Achievement(
        id: 'xp50',
        groupId: 'xp',
        title: 'First Steps',
        description: 'Reach 50 XP points total.',
        icon: Icons.star,
        currentProgress: 0,
        totalRequired: 50,
        isUnlocked: false,
      ),
      Achievement(
        id: 'xp250',
        groupId: 'xp',
        title: 'Rising Star',
        description: 'Reach 250 XP points total.',
        icon: Icons.star_half_outlined,
        currentProgress: 0,
        totalRequired: 250,
        isUnlocked: false,
      ),
      Achievement(
        id: 'xp1k',
        groupId: 'xp',
        title: 'Dedicated Learner',
        description: 'Reach 1,000 XP points total.',
        icon: Icons.star_rate_outlined,
        currentProgress: 0,
        totalRequired: 1000,
        isUnlocked: false,
      ),
      Achievement(
        id: 'xp5k',
        groupId: 'xp',
        title: 'Seasoned Veteran',
        description: 'Reach 5,000 XP points total.',
        icon: Icons.stars_outlined,
        currentProgress: 0,
        totalRequired: 5000,
        isUnlocked: false,
      ),
      Achievement(
        id: 'xp15k',
        groupId: 'xp',
        title: 'Ultimate Champion',
        description: 'Reach 15,000 XP points total.',
        icon: Icons.workspace_premium,
        currentProgress: 0,
        totalRequired: 15000,
        isUnlocked: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Group achievements by category
    final Map<String, List<Achievement>> grouped = {};
    for (var a in achievements) {
      grouped.putIfAbsent(a.groupId, () => []).add(a);
    }

    // Filter completed achievements
    final completed = achievements.where((a) => a.isUnlocked).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        
        // Section Header
        const Text(
          'Achievements',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        // XP and Streak Summary Cards
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

        // Grouped Achievements (Expandable)
        ...grouped.entries.map(
          (entry) => _buildAchievementGroup(entry.key, entry.value),
        ),

        // Completed Achievements Section
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

  /// Build summary card for XP and Streak display
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

  /// Build expandable achievement group
  Widget _buildAchievementGroup(String groupId, List<Achievement> group) {
    final isExpanded = expandedGroups[groupId] ?? false;

    // Find the first locked achievement to display at top
    final topAchievement = group.firstWhere(
      (a) => !a.isUnlocked,
      orElse: () => group.last,
    );

    // Get remaining locked achievements for expanded view
    final restAchievements = group
        .where((a) => a != topAchievement && !a.isUnlocked)
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // Top achievement card (always visible)
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
                // Visual indicator for expandable content
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
                // Expand/collapse indicator
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
          // Expanded list of remaining achievements
          if (isExpanded)
            Column(
              children: restAchievements.map(_buildAchievementCard).toList(),
            ),
        ],
      ),
    );
  }

  /// Build individual achievement card
  Widget _buildAchievementCard(
    Achievement a, {
    bool isTopOfGroup = false,
    List<Achievement>? group,
  }) {
    bool locked = !a.isUnlocked && a.currentProgress < a.totalRequired;

    // Special visual treatment for first locked achievement in group
    if (isTopOfGroup && group != null) {
      final firstLockedIndex = group.indexWhere((ach) => !ach.isUnlocked);
      if (firstLockedIndex != -1 && group[firstLockedIndex].id == a.id) {
        locked = false; // visually unlock for better UX
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
            // Achievement icon with conditional coloring
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
                  // Achievement title
                  Text(
                    a.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: locked ? Colors.grey : AppColors.textPrimary,
                    ),
                  ),
                  // Achievement description
                  Text(
                    a.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  // Progress bar visualization
                  LinearProgressIndicator(
                    value: a.progress.clamp(0, 1),
                    backgroundColor: Colors.grey[300],
                    color: locked ? Colors.grey : Colors.blue,
                  ),
                  const SizedBox(height: 4),
                  // Progress text or completion date
                  Text(
                    a.isUnlocked
                        ? 'Completed on ${a.unlockedDate?.toLocal()}'
                        : '${a.currentProgress}/${a.totalRequired}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            // Lock icon for locked achievements
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

  /// Build completed achievement card with special styling
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
