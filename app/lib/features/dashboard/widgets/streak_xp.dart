import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// -------------------------------
///  USER PROGRESS MODEL (XP, STREAK, ETC.)
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
    return next.isBefore(now) ? Duration.zero : next.difference(now);
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
///  DAILY CHALLENGE PAGE
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
      final minutes =
          remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds =
          remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
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
          content: Text("✅ You already completed today's challenge!"),
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
          title: const Text("Daily Challenge"),
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
          content:
              Text("❌ You did not pronounce it correctly. Try again tomorrow!"),
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
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _countdownText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

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

            ElevatedButton.icon(
              onPressed: completedToday ? null : _startChallenge,
              icon: const Icon(Icons.local_fire_department),
              label: const Text("Start Daily Challenge"),
              style: ElevatedButton.styleFrom(
                backgroundColor: completedToday ? Colors.grey : Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),

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
                  _updateCountdown();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Progress reset to 0")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              child: const Text("Reset All (Testing Only)"),
            ),
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
