import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/network/session_manager.dart';

// ignore_for_file: use_build_context_synchronously

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _notificationsKey = 'settings.notifications_enabled';
  static const _remindersKey = 'settings.daily_reminders_enabled';
  static const _autoPlayKey = 'settings.autoplay_audio_enabled';
  static const _analyticsKey = 'settings.analytics_enabled';

  bool _isLoading = true;
  bool _notificationsEnabled = true;
  bool _dailyRemindersEnabled = true;
  bool _autoPlayEnabled = false;
  bool _analyticsEnabled = true;

  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _prefs = prefs;
      _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
      _dailyRemindersEnabled = prefs.getBool(_remindersKey) ?? true;
      _autoPlayEnabled = prefs.getBool(_autoPlayKey) ?? false;
      _analyticsEnabled = prefs.getBool(_analyticsKey) ?? true;
      _isLoading = false;
    });
  }

  Future<void> _updatePreference(String key, bool value) async {
    final prefs = _prefs;
    if (prefs == null) return;
    await prefs.setBool(key, value);
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
                _buildSection(
                  title: 'Learning preferences',
                  child: Column(
                    children: [
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
                _buildSection(
                  title: 'Notifications',
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: _notificationsEnabled,
                        title: const Text('App notifications'),
                        subtitle: const Text(
                          'Be notified about new challenges and streaks',
                        ),
                        onChanged: (value) {
                          setState(() => _notificationsEnabled = value);
                          _updatePreference(_notificationsKey, value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  title: 'Privacy',
                  child: Column(
                    children: [
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
          child,
        ],
      ),
    );
  }

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
