import '../../../../core/common/colors.dart';
import 'package:app/features/dashboard/presentation/widgets/user_info_box.dart';
import 'package:app/features/dashboard/presentation/widgets/welcome_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/features/dashboard/presentation/widgets/home_sections.dart';
import 'package:app/features/ChatBotPage/chat_bot_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/network/progress_service.dart';
import '../../../../core/common/user_progress.dart';

/// ===========================================================================
/// HOME SCREEN - MAIN APPLICATION LANDING PAGE
/// ===========================================================================
///
/// PURPOSE:
/// - Primary landing page and navigation hub for the application
/// - Centralized access point to all main features and activities
/// - Personalized user dashboard with quick access to key functions
///
/// ARCHITECTURE:
/// - Stateful widget managing the main home interface
/// - Integrates multiple dashboard widgets for comprehensive overview
/// - Provides floating action button for quick chatbot access
///
/// LAYOUT STRUCTURE:
/// 1. App Bar: Branding and navigation
/// 2. User Info Box: Profile summary and statistics
/// 3. Welcome Back Box: Personalized greeting and quick actions
/// 4. Home Sections: Main activity cards and features
/// 5. Floating Action Button: Quick access to AI chatbot
/// ===========================================================================

class HomeScreen extends StatefulWidget {
  final VoidCallback? onFastPractice;

  const HomeScreen({super.key, this.onFastPractice});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String? _errorMessage;

  String _displayName = 'Guest';
  String _avatarUrl =
      'https://ui-avatars.com/api/?name=Guest&background=3B82F6&color=ffffff';
  String _proficiencyLevel = 'Pronunciation learner';

  int _activeDays = 0;
  int _challengesCompleted = 0;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserAndProgress();
  }

  Future<void> _loadCurrentUserAndProgress() async {
    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;

      // No authenticated user -> guest mode
      if (user == null) {
        if (!mounted) return;
        setState(() {
          _errorMessage = null;

          _displayName = 'Guest';
          _avatarUrl =
          'https://ui-avatars.com/api/?name=Guest&background=3B82F6&color=ffffff';
          _proficiencyLevel = 'Guest mode';

          _activeDays = 0;
          _challengesCompleted = 0;
        });
        return;
      }

      // Authenticated user: load profile + progress
      final userId = user.id;

      final profileResponse =
      await client.from('profiles').select().eq('id', userId).single();

      final String fullName = profileResponse['full_name'] ?? 'Learner';
      final String? avatarUrl = profileResponse['avatar_url'];

      // Use first name if available, else full name
      final String firstName =
      fullName.trim().split(' ').isNotEmpty ? fullName.split(' ').first : fullName;

      final ProgressService progressService = ProgressService();

      // ------------------------
      // 2) Load user_progress stats
      // ------------------------
      UserProgress? progress = await progressService.getUserProgress();

      // If there is no row yet, create one
      progress ??= await progressService.initializeUserProgress();

      // Fallback in case initializeUserProgress returns null somehow
      final int activeDays = progress.currentStreak;
      final int challengesCompleted = progress.challengesCompleted;

      if (!mounted) return;
      setState(() {
        _errorMessage = null;
        _displayName = firstName;
        _avatarUrl = avatarUrl ??
            'https://ui-avatars.com/api/?name=$firstName&background=3B82F6&color=ffffff';
        _proficiencyLevel = 'Pronunciation learner';
        _activeDays = activeDays;
        _challengesCompleted = challengesCompleted;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load your data. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Match the rest of the app status bar style
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadCurrentUserAndProgress,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error banner (if any)
                if (_errorMessage != null)
                  Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                // Top user info card (now with real stats)
                UserInfoBox(
                  name: _displayName,
                  avatarURL: _avatarUrl,
                  proficiencyLevel: _proficiencyLevel,
                  activeDays: _activeDays,
                  challengesCompleted: _challengesCompleted,
                ),

                const SizedBox(height: 8),

                // Welcome back header – shows first name or full name
                WelcomeBackBox(
                  name: _displayName,
                  onFastPractice: widget.onFastPractice,
                ),

                const SizedBox(height: 16),
                const HomeSections(),
              ],
            ),
          ),
        ),
      ),

      // Quick access floating action button for AI chatbot
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.chat),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotPage()),
          );
        },
      ),
    );
  }
}