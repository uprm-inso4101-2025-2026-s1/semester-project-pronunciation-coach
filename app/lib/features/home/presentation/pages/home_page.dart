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
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProgressService _progressService = ProgressService();

  bool _isLoading = true;
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
          _isLoading = false;
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

      // ------------------------
      // 1) Load profile (name)
      // ------------------------
      final profile = await client
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .maybeSingle();

      String? fullName;
      if (profile != null &&
          profile['full_name'] != null &&
          (profile['full_name'] as String).trim().isNotEmpty) {
        fullName = (profile['full_name'] as String).trim();
      }

      final metaName = user.userMetadata?['full_name'];
      final computedName = fullName ??
          (metaName is String && metaName.trim().isNotEmpty
              ? metaName.trim()
              : (user.email ?? 'User'));

      // ------------------------
      // 2) Load user_progress stats
      // ------------------------
      UserProgress? progress = await _progressService.getUserProgress();

      // If there is no row yet, create one
      progress ??= await _progressService.initializeUserProgress();

      // Fallback in case initializeUserProgress returns null somehow
      final int activeDays = progress.currentStreak;
      final int challengesCompleted = progress.challengesCompleted;

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = null;

        _displayName = computedName;
        _avatarUrl =
            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(computedName)}&background=3B82F6&color=ffffff';
        _proficiencyLevel = 'Pronunciation learner';

        // Map Supabase stats -> home UI
        _activeDays = activeDays;                     // "Active Days"
        _challengesCompleted = challengesCompleted;   // "Challenges Completed"
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Could not load your profile or progress. Showing default data.';

        _displayName = 'User';
        _avatarUrl =
            'https://ui-avatars.com/api/?name=User&background=3B82F6&color=ffffff';
        _proficiencyLevel = 'Pronunciation learner';

        _activeDays = 0;
        _challengesCompleted = 0;
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

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      // Main background color from app theme
      backgroundColor: AppColors.background,
      
      // Application header with branding
      appBar: AppBar(
        title: const Text(
          'Home Page',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 18,
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
                ),
              ],
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
              ),

              const SizedBox(height: 16),
              const HomeSections(),
            ],
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
