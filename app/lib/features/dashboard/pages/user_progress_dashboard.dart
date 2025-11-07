import 'package:app/features/dashboard/widgets/streak_xp.dart';
import 'package:app/features/homescreen/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:app/pace%20selector/pace_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../quiz/pages/audio_quiz_home_page.dart'; // CHANGED: Import audio quiz instead
import '../widgets/daily_challenge.dart';
import '../widgets/progress_visualization_widget.dart';
import '../widgets/recent_activity_timeline.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/features/profile/pages/profile_page.dart';
import '../../../core/constants/sound_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pronunciation Coach',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

/// -------------------------------
///  MAIN NAVIGATION SCREEN WITH BOTTOM TAB BAR
/// -------------------------------
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const UserProgressDashboard(),
      const DailyChallengePage(),
      const AudioQuizHomePage(),
      const ProfilePage(),
    ];
  }

  void _onTabTapped(int index) {
    // Play transition sound when changing tabs
    SoundService().playTransition();

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.local_activity),
              activeIcon: Icon(Icons.local_activity),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department_outlined),
              activeIcon: Icon(Icons.local_fire_department),
              label: 'Challenge',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.headphones_outlined),
              activeIcon: Icon(Icons.headphones),
              label: 'Quiz',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

/// -------------------------------
///  USER PROGRESS DASHBOARD (UPDATED - NO DRAWER)
/// -------------------------------
class UserProgressDashboard extends StatefulWidget {
  const UserProgressDashboard({super.key});

  @override
  State<UserProgressDashboard> createState() => _UserProgressDashboardState();
}

class _UserProgressDashboardState extends State<UserProgressDashboard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChallengesPage()),
              );
            },
            child: const Text(
              "Select Pace",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Daily Challenge Widget
              DailyChallengeWidget(currentStreak: 5, totalXp: 1250),
              const SizedBox(height: 20),

              // Display Selected Pace
              _buildSelectedPace(context),
              const SizedBox(height: 20),

              // Progress Overview Cards (Portrait Layout)
              _buildProgressOverview(),
              const SizedBox(height: 20),

              // Pronunciation Skills Progress
              const ProgressVisualizationWidget(),
              const SizedBox(height: 20),

              // Practice Statistics
              _buildPracticeStatistics(),
              const SizedBox(height: 20),

              // Recent Practice Sessions
              const RecentActivityTimeline(),

              // Add bottom padding for tab bar
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedPace(BuildContext context) {
    var appState = context.watch<MyAppState>();

    String paceText = 'âšª Not selected âšª';
    switch (appState.selectedPace) {
      case LearningPace.casual:
        paceText = 'ðŸŸ¡ Casual ðŸŸ¡';
        break;
      case LearningPace.standard:
        paceText = 'ðŸŸ  Standard ðŸŸ ';
        break;
      case LearningPace.intensive:
        paceText = 'ðŸ”´ Intensive ðŸ”´';
        break;
    }

    return Container(
      width: double.infinity,
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
        ],
      ),
      child: Text(
        'Selected Pace: $paceText',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildProgressOverview() {
    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            'Accuracy Rate',
            '89%',
            Icons.gps_fixed,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOverviewCard(
            'Words Practiced',
            '247',
            Icons.record_voice_over,
            AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+5%',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.progressValue),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildPracticeStatistics() {
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
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Week\'s Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Sessions',
                  '14',
                  Icons.mic,
                  AppColors.primary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Avg Score',
                  '87%',
                  Icons.grade,
                  AppColors.success,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Improved',
                  '23',
                  Icons.trending_up,
                  AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// -------------------------------
///  PROFILE PAGE - PLACEHOLDER
/// -------------------------------
class ProfilePagePlaceholder extends StatelessWidget {
  const ProfilePagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Profile Page',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Placeholder - Ready for Development',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 30),
            Card(
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Coming Soon!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'User profile management, settings, statistics, achievements, and account preferences will be implemented here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
