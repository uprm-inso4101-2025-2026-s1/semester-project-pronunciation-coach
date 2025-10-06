import 'dart:async';
import 'dart:math';
import 'package:app/features/homescreen/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:app/pace%20selector/pace_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../widgets/daily_challenge.dart';
import '../widgets/progress_visualization_widget.dart';
import '../widgets/recent_activity_timeline.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      const ProfilePagePlaceholder(),
    ];
  }

  void _onTabTapped(int index) {
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
        automaticallyImplyLeading: false, // Remove back button
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
              DailyChallengeWidget(
                currentStreak: 5, // TODO: Get from user progress
                totalXp: 1250, // TODO: Get from user progress
              ),
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

    String paceText = '⚪ Not selected ⚪';
    switch (appState.selectedPace) {
      case LearningPace.casual:
        paceText = '🟡 Casual 🟡';
        break;
      case LearningPace.standard:
        paceText = '🟠 Standard 🟠';
        break;
      case LearningPace.intensive:
        paceText = '🔴 Intensive 🔴';
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
        automaticallyImplyLeading: false, // Remove back button
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

/// -------------------------------
///  USER PROGRESS & DAILY CHALLENGE LOGIC
/// -------------------------------
class UserProgress {
  int streak;
  int points;
  DateTime? lastActiveDate;

  UserProgress({this.streak = 0, this.points = 0, this.lastActiveDate});

  static Future<UserProgress> load() async {
    final prefs = await SharedPreferences.getInstance();
    final streak = prefs.getInt("streak") ?? 0;
    final points = prefs.getInt("points") ?? 0;
    final lastDateString = prefs.getString("lastActiveDate");
    final lastDate = lastDateString != null
        ? DateTime.tryParse(lastDateString)
        : null;

    return UserProgress(
      streak: streak,
      points: points,
      lastActiveDate: lastDate,
    );
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("streak", streak);
    await prefs.setInt("points", points);
    if (lastActiveDate != null) {
      await prefs.setString(
        "lastActiveDate",
        lastActiveDate!.toIso8601String(),
      );
    }
  }

  bool hasCompletedToday() {
    if (lastActiveDate == null) return false;
    final today = DateTime.now();
    return today.year == lastActiveDate!.year &&
        today.month == lastActiveDate!.month &&
        today.day == lastActiveDate!.day;
  }

  Duration timeUntilNextChallenge() {
    if (lastActiveDate == null) return Duration.zero;
    final next = lastActiveDate!.add(const Duration(days: 1));
    final now = DateTime.now();
    return next.difference(now).isNegative
        ? Duration.zero
        : next.difference(now);
  }

  void completeActivity() {
    final today = DateTime.now();
    if (lastActiveDate != null) {
      final difference = today.difference(lastActiveDate!).inDays;
      if (difference == 1) {
        streak++;
      } else if (difference > 1) {
        streak = 1;
      }
    } else {
      streak = 1;
    }
    points += 100;
    lastActiveDate = today;
  }
}

/// -------------------------------
///  DAILY CHALLENGE PAGE WITH RANDOM PHRASES (FROM ORIGINAL FILE)
/// -------------------------------
class DailyChallengePage extends StatefulWidget {
  const DailyChallengePage({super.key});

  @override
  State<DailyChallengePage> createState() => _DailyChallengePageState();
}

class _DailyChallengePageState extends State<DailyChallengePage> {
  late UserProgress _userProgress;
  bool _loading = true;
  String? _currentPhrase;
  Timer? _timer;
  String _countdownText = "";

  final List<String> _phrases = [
    "Hello World",
    "Flutter is awesome",
    "Pronunciation coach",
    "Daily challenge",
    "Keep practicing",
    "Random phrase",
    "Good morning",
    "Stay focused",
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    _userProgress = await UserProgress.load();
    _updateCountdown();
    _startCountdownTimer();
    setState(() {
      _loading = false;
    });
  }

  void _updateCountdown() {
    final remaining = _userProgress.timeUntilNextChallenge();
    if (remaining == Duration.zero) {
      _countdownText = "¡New Daily Challenge Available!";
    } else {
      final hours = remaining.inHours.remainder(24).toString().padLeft(2, '0');
      final minutes = remaining.inMinutes
          .remainder(60)
          .toString()
          .padLeft(2, '0');
      final seconds = remaining.inSeconds
          .remainder(60)
          .toString()
          .padLeft(2, '0');
      _countdownText = "$hours:$minutes:$seconds until next challenge!";
    }
  }

  void _startCountdownTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _updateCountdown();
      });
    });
  }

  void _generateRandomPhrase() {
    final rand = Random();
    _currentPhrase = _phrases[rand.nextInt(_phrases.length)];
  }

  Future<void> _startChallenge() async {
    if (_userProgress.hasCompletedToday()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "✅ You already completed the Daily Challenge of today!",
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    _generateRandomPhrase();
    _showChallengeDialog();
  }

  void _showChallengeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("Daily Challenge:"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _currentPhrase ?? "",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Pronounce the phrase and confirm if you did it correctly.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final correcto = true; // Simulated speech recognition
                Navigator.pop(context);
                _handleChallengeResult(correcto);
              },
              style: ElevatedButton.styleFrom(foregroundColor: Colors.green),
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleChallengeResult(bool correcto) async {
    if (correcto) {
      setState(() {
        _userProgress.completeActivity();
        _updateCountdown();
      });

      await _userProgress.save();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🎉 Challenge completed! +100 XP"),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "❌ You did not pronounce it correctly. Try again tomorrow!",
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final completedToday = _userProgress.hasCompletedToday();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daily Challenge",
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        automaticallyImplyLeading:
            false, // Remove back button for tab navigation
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ------------------------------
            // Countdown / Next Challenge
            // ------------------------------
            Text(
              _countdownText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // ------------------------------
            // Streaks y Puntos XP visibles
            // ------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard(
                  icon: Icons.local_fire_department,
                  label: "Streak",
                  value: "${_userProgress.streak} days",
                  color: Colors.red,
                ),
                _buildStatCard(
                  icon: Icons.star,
                  label: "XP",
                  value: "${_userProgress.points} XP",
                  color: Colors.amber.shade800,
                ),
              ],
            ),
            const SizedBox(height: 40),

            // ------------------------------
            // Botón Iniciar Challenge
            // ------------------------------
            ElevatedButton.icon(
              onPressed: completedToday ? null : _startChallenge,
              icon: const Icon(Icons.local_fire_department),
              label: const Text("Start Daily Challenge"),
              style: ElevatedButton.styleFrom(
                backgroundColor: completedToday ? Colors.grey : Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16), // Espacio entre botones
            // ------------------------------
            // Botón Reset Progreso (solo para pruebas)
            // ------------------------------
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt("streak", 0);
                await prefs.setInt("points", 0);
                await prefs.remove("lastActiveDate");
                setState(() {
                  _userProgress.streak = 0;
                  _userProgress.points = 0;
                  _userProgress.lastActiveDate = null;
                  _updateCountdown(); // Reinicia el contador
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Progress reset to 0")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
              child: const Text("Reset All (Testing Only)"),
            ),

            // Add bottom padding for tab bar
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
