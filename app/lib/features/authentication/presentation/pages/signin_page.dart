import 'package:app/features/dashboard/presentation/pages/user_progress_dashboard.dart';
import 'package:app/features/authentication/presentation/widgets/text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/common/text_styles.dart';
// import '../widgets/loading_screens_factory.dart';
import '../widgets/loading_screens_manager.dart';
import 'package:app/core/network/supabase_client.dart';

import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  late final void Function(bool) _loadingListener;

  bool _loading = false;
  final LoadingSystem _loadingSystem = LoadingSystem();

  @override
  void initState() {
    super.initState();
    // Optional: Add listener for loading state changes
    _loadingListener = (isLoading) {
      if (mounted) {
        setState(() {
          _loading = isLoading;
        });
      }
    };
    _loadingSystem.addLoadingListener(_loadingListener);
  }

  @override
  void dispose() {
    _loadingSystem.removeLoadingListener(_loadingListener);
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.h)),
      ),
    );
  }

  // =============================================================================
  // DEMONSTRATING DESIGN PATTERNS IN USAGE:
  // =============================================================================
  //
  // FACTORY PATTERN: Creating loading strategy
  // - LoadingStrategyFactory.createRandomStrategy() for normal loading
  // - LoadingStrategyFactory.createPulsatingWave() for error state
  //
  // STRATEGY PATTERN: Interchangeable loading behaviors
  // - Different strategies can be swapped at runtime
  // - Each strategy provides different visual feedback
  //
  // OBSERVER PATTERN: Loading state management
  // - _loadingSystem.addLoadingListener() for state tracking
  // - Automatic UI updates based on loading state
  // =============================================================================

  Future<void> _onSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _loadingSystem.showLoading(
      context: context,
      message: 'Creating your account...',
      contextType: 'authentication',
    );

    try {
      final name = _nameCtrl.text.trim();
      final email = _emailCtrl.text.trim();
      final password = _passCtrl.text;

      // 1) Create auth user in Supabase
      final res = await AppSupabase.client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name}, // stored in user_metadata
      );

      // 2) If we already have a session (depends on your email-confirmation setting),
      //    create/update the row in `profiles`.
      if (res.user != null && res.session != null) {
        await AppSupabase.client.from('profiles').upsert({
          'id': res.user!.id, // auth uid
          'email': email,
          'full_name': name,
          'updated_at': DateTime.now().toIso8601String(),
        });
      }

      if (!mounted) return;
      _loadingSystem.hideLoading(context);

      if (res.session != null) {
        // Email confirmation OFF → we have a session; go to app
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        );
      } else {
        // Email confirmation ON → no session yet
        _showSnack(
          "We've sent a confirmation link to $email. Tap it to finish creating your account.",
        );
        // You can optionally pop back to login here if you prefer:
        // Navigator.of(context).pop();
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      _loadingSystem.hideLoading(context);
      _showSnack(e.message);
    } catch (e) {
      if (!mounted) return;
      _loadingSystem.hideLoading(context);
      _showSnack('Unexpected error. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _validateName(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Please enter your name';
    final nameReg = RegExp(
      r"^[A-Za-zÀ-ÖØ-öø-ÿĀ-ſƀ-ɏ]"
      r"(?:[A-Za-zÀ-ÖØ-öø-ÿĀ-ſƀ-ɏ\u0300-\u036F'’\-]*[A-Za-zÀ-ÖØ-öø-ÿĀ-ſƀ-ɏ])"
      r"(?:\s+[A-Za-zÀ-ÖØ-öø-ÿĀ-ſƀ-ɏ]"
      r"(?:[A-Za-zÀ-ÖØ-öø-ÿĀ-ſƀ-ɏ\u0300-\u036F'’\-]*[A-Za-zÀ-ÖØ-öø-ÿĀ-ſƀ-ɏ]))+$",
      unicode: true,
      caseSensitive: false,
    );
    if (!nameReg.hasMatch(value)) {
      return 'Please enter a valid name';
    }
    return null;
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Please enter your email';
    final emailReg = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailReg.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePass(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Please enter your password';
    final RegExp passReg = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[&*$%#])[A-Za-z\d&*$%#]{8,}$',
    );
    if (!passReg.hasMatch(value)) {
      return 'Password must include: \n1. Lower case letters, \n2. At least 1 special character (& * % #), \n3. At least 1 Upper case letter.';
    }
    return null;
  }

  String? _validateConfPass(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Please confirm your password';
    if (value != _passCtrl.text) {
      return 'Passwords do not match';
    }
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
                'Sign Up',
                style: AppTextStyles.welcomeTitle.copyWith(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 2.h),

              Text(
                "Create your account.",
                style: AppTextStyles.welcomeSubtitle.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),

              SizedBox(height: 2.h),

              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text:
                      'Already have an account? ', // Default style for this part
                  style: AppTextStyles.welcomeSubtitle.copyWith(
                    fontSize: 15.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.normal,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Click here',
                      style: AppTextStyles.welcomeSubtitle.copyWith(
                        fontSize: 15.sp,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white.withValues(alpha: 0.9),
                        decorationThickness: 0.15.h,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pop();
                        },
                    ),
                    TextSpan(
                      text:
                          ' to continue your pronunciation journey', // This part will be bold
                      style: AppTextStyles.welcomeSubtitle.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.normal,
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
                      // Full name
                      MyTextField(
                        controller: _nameCtrl,
                        labelText: 'First and Last Name',
                        hintText: 'John Doe, María García-López',
                        icon: Icon(
                          Icons.person,
                          color: AppColors.textMuted,
                          size: 20.sp,
                        ),
                        validator: _validateName,
                      ),

                      SizedBox(height: 4.h),

                      // Email Address Field
                      MyTextField(
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

                      SizedBox(height: 4.h),

                      // Password Field
                      MyTextField(
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

                      SizedBox(height: 4.h),

                      // Confirm password
                      MyTextField(
                        controller: _confirmPassCtrl,
                        isPass: true,
                        labelText: 'Confirm Password',
                        hintText: 'Enter your password again',
                        icon: Icon(
                          Icons.lock_outlined,
                          color: AppColors.textMuted,
                          size: 20.sp,
                        ),
                        validator: _validateConfPass,
                      ),

                      SizedBox(height: 4.h),

                      // Main Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 8.h,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _onSignIn,
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
              SizedBox(height: 6.h),

              // App Info Footer
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Text(
                      'Pronunciation Coach',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Master English pronunciation with interactive lessons',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 11.sp,
                      ),
                      textAlign: TextAlign.center,
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
