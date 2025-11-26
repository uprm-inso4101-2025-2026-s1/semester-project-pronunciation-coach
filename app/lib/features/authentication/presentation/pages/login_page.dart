import 'signin_page.dart';
import 'package:app/features/dashboard/presentation/pages/user_progress_dashboard.dart';
import '../widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/common/text_styles.dart';
import '../widgets/loading_screens_manager.dart';
import 'package:app/core/network/supabase_client.dart';
import 'package:app/core/common/sound_service.dart';

import 'dart:async'; // for auth state subscription
import 'reset_password_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, AuthChangeEvent;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/background_music_manager.dart';

/// ===========================================================================
/// LOGIN PAGE - AUTHENTICATION INTERFACE
/// ===========================================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form management
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  // UI state management
  bool _rememberMe = false;
  bool _loading = false;

  static const _rememberMeKey = 'remember_me';
  static const _savedEmailKey = 'saved_email';

  // Service dependencies
  final LoadingSystem _loadingSystem = LoadingSystem();
  final SoundService _soundService = SoundService();

  late final void Function(bool) _loadingListener;
  late final StreamSubscription _authSubscription;

  @override
  void initState() {
    super.initState();

    // Observer pattern: Listen to loading state changes
    _loadingListener = (isLoading) {
      if (mounted) {
        setState(() {
          _loading = isLoading;
        });
      }
    };
    _loadingSystem.addLoadingListener(_loadingListener);

    // Listen for Supabase auth state changes (including password recovery)
    _authSubscription = AppSupabase.client.auth.onAuthStateChange.listen((
      data,
    ) {
      final event = data.event;

      if (event == AuthChangeEvent.passwordRecovery) {
        // This means the user came back from the reset email link
        if (!mounted) return;

        // Optional: sound effect
        _soundService.playTransition();

        // Navigate to the ResetPasswordPage
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
        );
      }
    });

    // [MUSIC START]: Starts music when app opens.
    BackgroundMusicManager().playAuthMusic();

    _loadRememberedCredentials();
  }

  Future<void> _loadRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(_rememberMeKey) ?? false;
    final savedEmail = prefs.getString(_savedEmailKey);

    if (!mounted) return;

    setState(() {
      _rememberMe = remember;
      if (remember && savedEmail != null && savedEmail.isNotEmpty) {
        _emailCtrl.text = savedEmail;
      }
    });

    // RememberMe logic
    if (remember && AppSupabase.client.auth.currentSession != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _soundService.playTransition();

        // [MUSIC STOP]: Stop music before entering app automatically
        await BackgroundMusicManager().stopMusic();

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();

    // Cleanup: Remove listeners and controllers
    _loadingSystem.removeLoadingListener(_loadingListener);
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  /// Display snackbar message for user feedback
  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.h)),
      ),
    );
  }

  /// Handle user sign-in authentication
  Future<void> _onSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    // Play loading sound for authentication process
    _soundService.playFactReveal();

    // Show loading overlay using LoadingSystem
    // We use 'context' directly because we are in a State class
    _loadingSystem.showLoading(
      context: context,
      message: 'Signing you in...',
      contextType: 'authentication',
    );

    try {
      final email = _emailCtrl.text.trim();
      final password = _passCtrl.text;

      // 1. Sign in with Supabase authentication (Async Gap 1)
      await AppSupabase.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // 2. Handle Shared Preferences (Async Gap 2)
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setBool(_rememberMeKey, true);
        await prefs.setString(_savedEmailKey, email);
      } else {
        await prefs.setBool(_rememberMeKey, false);
        await prefs.remove(_savedEmailKey);
      }

      // CHECK MOUNTED before using context after async gaps
      if (!mounted) return;

      // Authentication successful
      _soundService.playLoadingSuccess();
      _loadingSystem.hideLoading(context);

      // 3. Stop music (Async Gap 3)
      await BackgroundMusicManager().stopMusic();

      // CHECK MOUNTED AGAIN before navigation
      if (!mounted) return;

      // Navigate to main app screen
      _soundService.playTransition();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } on AuthException catch (e) {
      // Handle authentication-specific errors
      if (!mounted) return;
      _soundService.playWrongAnswer();
      _loadingSystem.hideLoading(context);

      _showSnack(e.message);
    } catch (e) {
      // Handle generic errors
      if (!mounted) return;
      _soundService.playWrongAnswer();
      _loadingSystem.hideLoading(context);

      _showSnack('Unexpected error. Please try again.');
    } finally {
      // Reset loading state
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Navigate to account creation screen
  void _onCreateAccount() {
    _soundService.playButtonClick();
    // Music does not stop here. It continues playing in the next screen.
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SigninPage()));
  }

  /// Handle forgot password flow (placeholder)
  void _onForgotPassword() {
    _soundService.playButtonClick();
    // _showSnack('Password reset feature coming soon!');
    Navigator.of(context).pushNamed('/forgot-password');
  }

  /// Toggle remember me preference
  void _onRememberMeChanged(bool? value) {
    _soundService.playButtonClick();
    final newValue = value ?? false;

    setState(() => _rememberMe = newValue);

    // Actualizar SharedPreferences en segundo plano
    () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberMeKey, newValue);

      if (!newValue) {
        // Si el usuario apagó Remember me, limpiamos el email guardado
        await prefs.remove(_savedEmailKey);
      } else {
        // Si lo prende y ya hay email escrito, lo guardamos
        final currentEmail = _emailCtrl.text.trim();
        if (currentEmail.isNotEmpty) {
          await prefs.setString(_savedEmailKey, currentEmail);
        }
      }
    }();
  }

  /// Build email field with tap sound functionality
  Widget _buildEmailField() {
    return GestureDetector(
      onTap: () {
        _soundService.playButtonClick();
        FocusScope.of(context).requestFocus(FocusNode());
        Future.delayed(Duration.zero, () {
          if (mounted) {
            FocusScope.of(context).requestFocus(FocusNode());
            _emailCtrl.selection = TextSelection.collapsed(
              offset: _emailCtrl.text.length,
            );
          }
        });
      },
      child: MyTextField(
        controller: _emailCtrl,
        labelText: 'Email Address',
        hintText: 'your@email.com',
        icon: Icon(
          Icons.email_outlined,
          color: AppColors.textMuted,
          size: 20.sp,
        ),
        validator: _validateEmail,
      ),
    );
  }

  /// Build password field with tap sound functionality
  Widget _buildPasswordField() {
    return GestureDetector(
      onTap: () {
        _soundService.playButtonClick();
        FocusScope.of(context).requestFocus(FocusNode());
        Future.delayed(Duration.zero, () {
          if (mounted) {
            FocusScope.of(context).requestFocus(FocusNode());
            _passCtrl.selection = TextSelection.collapsed(
              offset: _passCtrl.text.length,
            );
          }
        });
      },
      child: MyTextField(
        controller: _passCtrl,
        isPass: true,
        labelText: 'Password',
        hintText: 'Enter your password',
        icon: Icon(
          Icons.lock_outlined,
          color: AppColors.textMuted,
          size: 20.sp,
        ),
        validator: _validatePass,
      ),
    );
  }

  /// Validate email format
  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Please enter your email';
    final emailReg = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailReg.hasMatch(value)) return 'Please enter a valid email address';
    return null;
  }

  /// Validate password requirements
  String? _validatePass(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Please enter your password';
    if (value.length < 4) return 'Password must be at least 4 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section
              SizedBox(height: 8.h),
              Text(
                'Welcome Back',
                style: AppTextStyles.welcomeTitle.copyWith(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 4.h),

              Text.rich(
                TextSpan(
                  text: 'Log In ',
                  style: AppTextStyles.welcomeSubtitle.copyWith(
                    fontSize: 15.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'to continue your pronunciation journey',
                      style: AppTextStyles.welcomeSubtitle.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: 'If you do not have an account, ',
                  style: AppTextStyles.welcomeSubtitle.copyWith(
                    fontSize: 15.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Create New Account ',
                      style: AppTextStyles.welcomeSubtitle.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    TextSpan(
                      text: 'to begin your pronunciation journey',
                      style: AppTextStyles.welcomeSubtitle.copyWith(
                        fontSize: 15.sp,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 6.h),

              // Login Form Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(4.w),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow.withValues(alpha: 0.3),
                      blurRadius: 6.w,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Email field with tap sound
                      _buildEmailField(),

                      SizedBox(height: 4.h),

                      // Password Field with tap sound
                      _buildPasswordField(),

                      SizedBox(height: 1.h),

                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Remember Me
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: _onRememberMeChanged,
                                activeColor: AppColors.primary,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              Text(
                                'Remember me',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),

                          // Forgot password
                          TextButton(
                            onPressed: _onForgotPassword,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),

                      // Main Sign In button
                      SizedBox(
                        width: double.infinity,
                        height: 8.h,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _onSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.w),
                            ),
                            elevation: 4,
                            shadowColor: AppColors.primary.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          child: _loading
                              ? SizedBox(
                                  width: 6.w,
                                  height: 6.w,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login, size: 18.sp),
                                    SizedBox(width: 3.w),
                                    Text(
                                      'Sign In to Continue',
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Create Account button
                      SizedBox(
                        width: double.infinity,
                        height: 8.h,
                        child: ElevatedButton(
                          onPressed: _onCreateAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.w),
                            ),
                            elevation: 4,
                            shadowColor: AppColors.success.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_add, size: 18.sp),
                              SizedBox(width: 3.w),
                              Text(
                                'Create New Account',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),

              // Bottom Spacing
              SizedBox(height: 5.h),

              // App info footer
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: Text(
                        'Pronunciation Coach',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Master English pronunciation with interactive lessons',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12.5.sp,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
