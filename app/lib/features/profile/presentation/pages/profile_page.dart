import 'package:flutter/material.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/common/user_progress.dart';
import '../../../../core/network/progress_service.dart';
import '../../../../core/network/supabase_client.dart';
import '../../widgets/achievements_xp.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProgress? _userProgress;
  bool _isLoading = true;
  String? _error;
  bool _isGuest = false;

  String _userEmail = 'Loading...';

  int _getUserLevel(int xp) {
    if (xp >= 15000) return 5;
    if (xp >= 5000) return 4;
    if (xp >= 1000) return 3;
    if (xp >= 250) return 2;
    if (xp >= 50) return 1;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _loadUserProgress();
  }

  Future<void> _loadUserProgress() async {
    try {
      final progressService = ProgressService();
      final isGuest = progressService.isGuest;

      if (mounted) {
        setState(() {
          _isGuest = isGuest;
        });
      }

      final currentUser = AppSupabase.client.auth.currentUser;
      if (currentUser != null) {
        setState(() {
          _userEmail = currentUser.email ?? 'user@example.com';
        });
      } else {
        setState(() {
          _userEmail = 'guest@example.com';
        });
      }

      if (!isGuest) {
        final userProgress = await progressService.getUserProgress();

        if (mounted) {
          setState(() {
            _userProgress = userProgress;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _userProgress = null;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/settings'),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildAchievementsSection(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------
  //                 IMPROVED PROFILE HEADER
  // -------------------------------------------------------
  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Bigger level circle
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.15),
                  Colors.blue.withOpacity(0.08),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Lvl",
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _isGuest || _userProgress == null
                        ? '0'
                        : _getUserLevel(_userProgress!.totalXp).toString(),
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Email (always one line)
          SizedBox(
            width: double.infinity,
            child: Text(
              _userEmail,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  //              ACHIEVEMENTS SECTION LOGIC
  // -------------------------------------------------------
  Widget _buildAchievementsSection() {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return _buildErrorCard();
    }

    if (_isGuest || _userProgress == null) {
      return _buildGuestMessage();
    }

    return AchievementsSection(userProgress: _userProgress!);
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _defaultCardDecoration(),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Error loading achievements',
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadUserProgress,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestMessage() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _defaultCardDecoration(),
      child: Column(
        children: [
          Icon(Icons.lock_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Login to View Achievements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create an account to track your progress and unlock achievements',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  BoxDecoration _defaultCardDecoration() {
    return BoxDecoration(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}
