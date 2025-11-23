import 'package:flutter/material.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/common/user_progress.dart';
import '../../../../core/network/progress_service.dart';
import '../../../../core/network/supabase_client.dart';
import '../../widgets/achievements_xp.dart';

/// ===========================================================================
/// PROFILE PAGE - USER PROFILE AND ACHIEVEMENTS INTERFACE
/// ===========================================================================
///
/// PURPOSE:
/// - Central hub for user profile management and achievement tracking
/// - Displays user progress, statistics, and earned achievements
/// - Provides access to app settings and information
/// - Handles both authenticated and guest user states
///
/// ARCHITECTURE:
/// - Stateful widget with expandable menu overlay
/// - Integration with ProgressService for real-time user data
/// - Dynamic content based on authentication status
/// - Comprehensive error handling and loading states
///
/// KEY FEATURES:
/// - Expandable side menu for additional options
/// - Achievement and progress visualization
/// - Guest user handling with appropriate messaging
/// - Responsive design with smooth animations
/// ===========================================================================

// Profile page
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Menu state management
  bool _isMenuExpanded = false;

  // User progress data state
  UserProgress? _userProgress;
  bool _isLoading = true;
  String? _error;
  bool _isGuest = false;

  String? _fullName;
  bool _isNameLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProgress();
    _loadUserName();
  }

  /// Load user progress data from ProgressService
  /// Handles both authenticated and guest user scenarios
  Future<void> _loadUserProgress() async {
    try {
      final progressService = ProgressService();

      // Check if user is a guest
      final isGuest = progressService.isGuest;

      if (mounted) {
        setState(() {
          _isGuest = isGuest;
        });
      }

      // Only load progress if NOT a guest
      if (!isGuest) {
        final userProgress = await progressService.getUserProgress();

        if (mounted) {
          setState(() {
            _userProgress = userProgress;
            _isLoading = false;
          });
        }
      } else {
        // Guest user - no data to load
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

  Future<void> _loadUserName() async {
    try {
      final name = await AppSupabase.getUserName();
      if (mounted) {
        setState(() {
          _fullName = name ?? "Guest User";
          _isNameLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _fullName = "Guest User";
          _isNameLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Custom app bar with menu toggle
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                // Menu toggle button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isMenuExpanded = !_isMenuExpanded;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.menu, color: Colors.blue, size: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Backdrop overlay for menu dismissal
          if (_isMenuExpanded)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isMenuExpanded = false;
                  });
                },
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),

          // Main Content Area
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Header Section
                Container(
                  padding: const EdgeInsets.all(24),
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
                    children: [
                      // User Avatar
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue.withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // User Name
                      _isNameLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              _fullName ?? "Guest User",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                      // User Role
                      const Text(
                        'Pronunciation Learner',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Achievements Sections - Dynamic content based on user state
                _buildAchievementsSection(),

                // Bottom padding for tab bar
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Expandable Menu Overlay
          if (_isMenuExpanded)
            Positioned(
              top: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(-2, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Menu Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Menu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),

                    // Menu Options List
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildMenuOption(
                              icon: Icons.settings,
                              title: 'Settings',
                              subtitle: 'App preferences and configuration',
                              onTap: () {
                                setState(() {
                                  _isMenuExpanded = false;
                                });
                                Navigator.of(context).pushNamed('/settings');
                              },
                            ),
                            const Divider(height: 1),
                            _buildMenuOption(
                              icon: Icons.help_outline,
                              title: 'Help & Support',
                              subtitle: 'Get help and contact support',
                              onTap: () {
                                setState(() {
                                  _isMenuExpanded = false;
                                });
                                _showComingSoonDialog(
                                  context,
                                  'Help & Support',
                                );
                              },
                            ),
                            const Divider(height: 1),
                            _buildMenuOption(
                              icon: Icons.info_outline,
                              title: 'About',
                              subtitle: 'App version and information',
                              onTap: () {
                                setState(() {
                                  _isMenuExpanded = false;
                                });
                                _showAboutDialog(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build achievements section with dynamic content based on user state
  Widget _buildAchievementsSection() {
    // Show loading indicator
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // Show error state
    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(24),
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

    // Show guest message
    if (_isGuest || _userProgress == null) {
      return Container(
        padding: const EdgeInsets.all(24),
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

    // Show achievements with real data
    return AchievementsSection(userProgress: _userProgress!);
  }

  /// Build individual menu option item
  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  /// Show coming soon dialog for unfinished features
  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$feature - Coming Soon!'),
          content: Text(
            'The $feature feature is currently under development and will be available in a future update.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Show about dialog with app information
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Pronunciation Coach'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Version: 1.0.0'),
              SizedBox(height: 8),
              Text('Built with Flutter'),
              SizedBox(height: 8),
              Text('© 2024 Pronunciation Coach Team'),
              SizedBox(height: 16),
              Text(
                'Help users improve their pronunciation skills through interactive challenges and progress tracking.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
