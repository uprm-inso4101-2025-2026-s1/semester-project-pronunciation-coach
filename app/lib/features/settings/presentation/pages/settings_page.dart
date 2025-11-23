import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/network/session_manager.dart';
import '../../domain/settings_algebra.dart';

// ignore_for_file: use_build_context_synchronously

/// ===========================================================================
/// SETTINGS PAGE
///
/// This file implements the user settings interface for the Pronunciation Coach app.
/// It provides:
/// - User account management and authentication status
/// - Learning preferences configuration
/// - Notification settings control
/// - Privacy and analytics preferences
/// - Persistent settings storage using SharedPreferences
///
/// KEY FEATURES:
/// - Guest vs authenticated user differentiation
/// - Persistent preference storage
/// - Account management options
/// - Security controls (sign out)
/// - Work-in-progress feature placeholders
/// ===========================================================================

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // SharedPreferences keys for persistent storage
  static const _notificationsKey = 'settings.notifications_enabled';
  static const _remindersKey = 'settings.daily_reminders_enabled';
  static const _autoPlayKey = 'settings.autoplay_audio_enabled';
  static const _analyticsKey = 'settings.analytics_enabled';

  // Algebraic settings state management
  bool _isLoading = true;
  late SettingsState _currentSettings;
  final SettingsAlgebra _settingsAlgebra = SettingsAlgebraImplementation();
  late SharedPreferences _prefs;

  // Legacy boolean variables (could be migrated to algebra later)
  late bool _autoPlayEnabled;
  late bool _dailyRemindersEnabled;
  late bool _analyticsEnabled;

  // Algebraic state getters
  bool get _notificationsEnabled => _currentSettings.notifications;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// Loads settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load notifications which is part of our algebra
    final notifications = prefs.getBool(_notificationsKey) ?? true;

    // Create algebraic state - start with default and override notifications
    _currentSettings = SettingsState.defaultState();
    if (!notifications) {
      _currentSettings = _settingsAlgebra.toggleNotifications(_currentSettings);
    }

    setState(() {
      _prefs = prefs;
      _isLoading = false;
    });
  }

  /// Algebraic wrapper for toggle notifications
  void _toggleNotifications() {
    setState(() {
      _currentSettings = _settingsAlgebra.toggleNotifications(_currentSettings);
    });
    _saveSettings(); // Save to SharedPreferences
  }

  /// Saves current algebraic state to SharedPreferences
  Future<void> _saveSettings() async {
    await _prefs.setBool(_notificationsKey, _currentSettings.notifications);
    // Could save other settings here in the future
  }

  /// Updates a preference value in SharedPreferences
  Future<void> _updatePreference(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final isGuest = user == null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textPrimary,
        title: const Text('Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ACCOUNT SECTION
                _buildSection(
                  title: 'Account',
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.withValues(alpha: 0.1),
                          child: const Icon(Icons.person, color: Colors.blue),
                        ),
                        title: Text(
                          isGuest
                              ? 'Guest user'
                              : (user.email ?? 'Unknown user'),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          isGuest
                              ? 'Sign in to sync your progress across devices'
                              : 'Manage your profile information',
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                      // PASSWORD CHANGE (AUTHENTICATED USERS ONLY)
                      if (!isGuest) ...[
                        const Divider(height: 0),
                        ListTile(
                          leading: const Icon(
                            Icons.lock_outline,
                            color: Colors.blue,
                          ),
                          title: const Text('Change password'),
                          subtitle: const Text(
                            'Update your account security settings',
                          ),
                          onTap: () => _showWorkInProgressDialog(
                            context,
                            title: 'Change password',
                            message:
                                'Password updates will be available soon. You can update your password via the web dashboard for now.',
                          ),
                        ),
                      ],
                      // ACCOUNT CREATION (GUEST USERS ONLY)
                      if (isGuest) ...[
                        const Divider(height: 0),
                        ListTile(
                          leading: const Icon(Icons.login, color: Colors.blue),
                          title: const Text('Create an account'),
                          subtitle: const Text(
                            'Unlock achievements, stats, and cloud sync',
                          ),
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil('/login', (route) => false),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // LEARNING PREFERENCES SECTION
                _buildSection(
                  title: 'Learning preferences',
                  child: Column(
                    children: [
                      // AUTO-PLAY PRONUNCIATIONS SETTING
                      SwitchListTile(
                        value: _autoPlayEnabled,
                        title: const Text('Auto-play pronunciations'),
                        subtitle: const Text(
                          'Automatically play audio examples on new lessons',
                        ),
                        onChanged: (value) {
                          setState(() => _autoPlayEnabled = value);
                          _updatePreference(_autoPlayKey, value);
                        },
                      ),
                      // DAILY PRACTICE REMINDERS SETTING
                      SwitchListTile(
                        value: _dailyRemindersEnabled,
                        title: const Text('Daily practice reminders'),
                        subtitle: const Text(
                          'Stay on track with motivational nudges',
                        ),
                        onChanged: (value) {
                          setState(() => _dailyRemindersEnabled = value);
                          _updatePreference(_remindersKey, value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // NOTIFICATIONS SECTION
                _buildSection(
                  title: 'Notifications',
                  child: Column(
                    children: [
                      // APP NOTIFICATIONS SETTING - Using Algebraic Operations
                      SwitchListTile(
                        value: _notificationsEnabled,
                        title: const Text('App notifications'),
                        subtitle: const Text(
                          'Be notified about new challenges and streaks',
                        ),
                        onChanged: (_) =>
                            _toggleNotifications(), // Algebraic operation
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // PRIVACY SECTION
                _buildSection(
                  title: 'Privacy',
                  child: Column(
                    children: [
                      // ANALYTICS SHARING SETTING
                      SwitchListTile(
                        value: _analyticsEnabled,
                        title: const Text('Share anonymous usage analytics'),
                        subtitle: const Text(
                          'Help us improve Pronunciation Coach',
                        ),
                        onChanged: (value) {
                          setState(() => _analyticsEnabled = value);
                          _updatePreference(_analyticsKey, value);
                        },
                      ),
                      // PRIVACY POLICY LINK
                      ListTile(
                        leading: const Icon(
                          Icons.description_outlined,
                          color: Colors.blue,
                        ),
                        title: const Text('Privacy policy'),
                        onTap: () => _showWorkInProgressDialog(
                          context,
                          title: 'Privacy policy',
                          message:
                              'The privacy policy is being finalized. Please check back soon or contact support for details.',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // SECURITY SECTION (AUTHENTICATED USERS ONLY)
                if (!isGuest)
                  _buildSection(
                    title: 'Security',
                    child: ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.redAccent,
                      ),
                      title: const Text(
                        'Sign out',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                      onTap: () => _confirmSignOut(context),
                    ),
                  ),
              ],
            ),
    );
  }

  /// Builds a consistent settings section with title and content
  /// [title]: Section header text
  /// [child]: Section content widgets
  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Divider(height: 0),
          // Section content
          child,
        ],
      ),
    );
  }

  /// Shows a dialog for features that are not yet implemented
  /// [context]: BuildContext for showing the dialog
  /// [title]: Dialog title
  /// [message]: Dialog content message
  void _showWorkInProgressDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  /// Shows confirmation dialog and handles user sign out process
  /// [context]: BuildContext for showing the dialog and navigation
  Future<void> _confirmSignOut(BuildContext context) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text(
          'Are you sure you want to sign out of Pronunciation Coach?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
      final navigator = Navigator.of(context);
      await SessionManager.instance.safeSignOut();
      if (mounted) {
        navigator.pushNamedAndRemoveUntil('/login', (route) => false);
      }
    }
  }
}
