// /app/lib/features/authentication/presentation/pages/forgot_password_page.dart

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:app/core/network/supabase_client.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/common/text_styles.dart';
import '../widgets/text_field.dart';
import '../widgets/loading_screens_manager.dart';
import '/core/common/sound_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

// ignore_for_file: use_build_context_synchronously

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  final LoadingSystem _loadingSystem = LoadingSystem();
  final SoundService _soundService = SoundService();

  bool _loading = false;
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
  }

  @override
  void dispose() {
    _loadingSystem.removeLoadingListener(_loadingListener);
    _emailCtrl.dispose();
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

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Please enter your email';
    final emailReg = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailReg.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    _soundService.playButtonClick();

    _loadingSystem.showLoading(
      context: context,
      message: 'Sending reset link...',
      contextType: 'authentication',
    );

    final email = _emailCtrl.text.trim();

    try {
      // NOTE: You must configure this URL in Supabase Auth → Redirect URLs.
      // For mobile with deep links, you may use a custom scheme like:
      //   pronunciationcoach://reset-password
      // For web, you can point to your web app's /reset-password route.
      const redirectUrl = 'pronunciationcoach://reset-password';

      await AppSupabase.client.auth.resetPasswordForEmail(
        email,
        redirectTo: redirectUrl,
      );

      _loadingSystem.hideLoading(context);

      // IMPORTANT: generic message – do not reveal whether email exists
      _showSnack(
        'If an account exists for this email, a reset link has been sent.',
      );

      // Go back to login
      Navigator.of(context).pop();
    } on AuthException catch (e) {
      _loadingSystem.hideLoading(context);
      _showSnack(e.message);
    } catch (_) {
      _loadingSystem.hideLoading(context);
      _showSnack('Unexpected error. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
              SizedBox(height: 8.h),
              Text(
                'Forgot Password',
                style: AppTextStyles.welcomeTitle.copyWith(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Enter the email associated with your account and we\'ll send you a reset link.',
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
                      SizedBox(
                        width: double.infinity,
                        height: 8.h,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _onSubmit,
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
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.send, size: 18.sp),
                                    SizedBox(width: 3.w),
                                    Text(
                                      'Send Reset Link',
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
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Back to Login',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
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
