// /app/lib/features/authentication/presentation/pages/reset_password_page.dart

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:app/core/network/supabase_client.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/common/text_styles.dart';
import '../widgets/text_field.dart';
import '../widgets/loading_screens_manager.dart';
import '/core/common/sound_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, UserAttributes;

// ignore_for_file: use_build_context_synchronously

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final LoadingSystem _loadingSystem = LoadingSystem();
  final SoundService _soundService = SoundService();

  bool _loading = false;
  bool _invalidSession = false;
  late final void Function(bool) _loadingListener;

  @override
  void initState() {
    super.initState();
    _loadingListener = (isLoading) {
      if (mounted) {
        setState(() => _loading = isLoading);
      }
    };
    _loadingSystem.addLoadingListener(_loadingListener);

    // If there is no current session, the user probably didn't come from a valid reset link
    final session = AppSupabase.client.auth.currentSession;
    if (session == null) {
      _invalidSession = true;
    }
  }

  @override
  void dispose() {
    _loadingSystem.removeLoadingListener(_loadingListener);
    _passCtrl.dispose();
    _confirmCtrl.dispose();
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

  String? _validatePass(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Please enter your new password';
    // You can reuse the same rules as Sign Up if you want:
    final RegExp passReg = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[&*$%#])[A-Za-z\d&*$%#]{8,}$',
    );
    if (!passReg.hasMatch(value)) {
      return 'Password must include: \n1. Lowercase letters\n2. At least 1 special character (& * % #)\n3. At least 1 uppercase letter\n4. Minimum 8 characters.';
    }
    return null;
  }

  String? _validateConfirm(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Please confirm your password';
    if (value != _passCtrl.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    _soundService.playButtonClick();

    _loadingSystem.showLoading(
      context: context,
      message: 'Updating your password...',
      contextType: 'authentication',
    );

    try {
      final newPassword = _passCtrl.text.trim();

      await AppSupabase.client.auth.updateUser(
        // Uses current (recovery) session set by Supabase from the reset link
        // If the session is invalid/expired, AuthException will be thrown.
        UserAttributes(password: newPassword),
      );

      _loadingSystem.hideLoading(context);
      _soundService.playLoadingSuccess();

      _showSnack('Password updated successfully. Please log in again.');

      // Go back to login clearing the stack
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } on AuthException catch (e) {
      _loadingSystem.hideLoading(context);
      _soundService.playWrongAnswer();
      _showSnack(e.message);
    } catch (_) {
      _loadingSystem.hideLoading(context);
      _soundService.playWrongAnswer();
      _showSnack('Unexpected error. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_invalidSession) {
      // User didn't come from a valid reset link
      return Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.link_off, size: 40.sp, color: Colors.white),
                  SizedBox(height: 3.h),
                  Text(
                    'Invalid or Expired Link',
                    style: AppTextStyles.welcomeTitle.copyWith(
                      fontSize: 22.sp,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'This password reset link is invalid or has expired. Please request a new reset link.',
                    style: AppTextStyles.welcomeSubtitle.copyWith(
                      fontSize: 13.sp,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    width: double.infinity,
                    height: 7.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/forgot-password',
                          (_) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cardBackground,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                      ),
                      child: Text(
                        'Request New Reset Link',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),
              Text(
                'Set New Password',
                style: AppTextStyles.welcomeTitle.copyWith(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Choose a new password for your account.',
                style: AppTextStyles.welcomeSubtitle.copyWith(
                  fontSize: 13.sp,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6.h),
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
                      MyTextField(
                        controller: _passCtrl,
                        isPass: true,
                        labelText: 'New Password',
                        hintText: 'Enter your new password',
                        icon: Icon(
                          Icons.lock_reset_outlined,
                          color: AppColors.textMuted,
                          size: 20.sp,
                        ),
                        validator: _validatePass,
                      ),
                      SizedBox(height: 4.h),
                      MyTextField(
                        controller: _confirmCtrl,
                        isPass: true,
                        labelText: 'Confirm New Password',
                        hintText: 'Enter your new password again',
                        icon: Icon(
                          Icons.lock_outline,
                          color: AppColors.textMuted,
                          size: 20.sp,
                        ),
                        validator: _validateConfirm,
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: double.infinity,
                        height: 8.h,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _onSubmit,
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
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle, size: 18.sp),
                                    SizedBox(width: 3.w),
                                    Text(
                                      'Update Password',
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 6.h),
            ],
          ),
        ),
      ),
    );
  }
}
