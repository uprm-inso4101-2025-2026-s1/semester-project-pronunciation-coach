import 'package:app/features/dashboard/pages/user_progress_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../loading_screens/loading_screens_factory.dart';
import '../loading_screens/loading_screens_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _rememberMe = false;
  bool _loading = false;
  final LoadingSystem _loadingSystem = LoadingSystem();

  @override
  void initState() {
    super.initState();
    // Optional: Add listener for loading state changes
    _loadingSystem.addLoadingListener((isLoading) {
      if (mounted) {
        setState(() {
          _loading = isLoading;
        });
      }
    });
  }

  @override
  void dispose() {
    _loadingSystem.removeLoadingListener((isLoading) {});
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.h)),
    ));
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
    if (!_formKey.currentState!.validate()) return;
    
    // Show loading with random strategy (FACTORY + STRATEGY PATTERNS)
    _loadingSystem.showLoading(
      context: context,
      message: 'Signing you in...',
      contextType: 'authentication',
    );

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      if (_passCtrl.text.length < 4) {
        throw Exception('Invalid credentials. Please check your email and password.');
      }
      
      if (!mounted) return;
      
      // Simulate successful login process
      await Future.delayed(const Duration(milliseconds: 1200));
      
      _loadingSystem.hideLoading(context);
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
      
    } catch (e) {
      _loadingSystem.hideLoading(context);
      
      // ... later for error state, use specific strategy
      final errorStrategy = LoadingStrategyFactory.createPulsatingWave(
        primaryColor: AppColors.danger, // Customized for error state
      );
      
      _loadingSystem.showLoading(
        context: context,
        message: 'Authentication Failed',
        customStrategy: errorStrategy, // STRATEGY PATTERN: Different behavior
      );
      
      await Future.delayed(const Duration(milliseconds: 1500));
      
      _loadingSystem.hideLoading(context);
      
      _showSnack(e.toString().replaceFirst('Exception: ', ''));
      
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Please enter your email';
    final emailReg = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailReg.hasMatch(value)) return 'Please enter a valid email address';
    return null;
  }

  String? _validatePass(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Please enter your password';
    if (value.length < 4) return 'Password must be at least 4 characters';
    return null;
  }

  void _onCreateAccount() {
    _showSnack('Account creation feature coming soon!');
  }

  void _onForgotPassword() {
    _showSnack('Password reset feature coming soon!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              SizedBox(height: 2.h),
              Text(
                'Sign in to continue your pronunciation journey',
                style: AppTextStyles.welcomeSubtitle.copyWith(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              SizedBox(height: 10.h),

              // Login Form Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(4.w),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow.withOpacity(0.3),
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
                      // Email Field
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.textMuted,
                          ),
                          hintText: 'your@email.com',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textMuted.withOpacity(0.6),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: BorderSide(color: AppColors.primary, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: BorderSide(color: AppColors.danger),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: BorderSide(color: AppColors.danger, width: 2),
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppColors.textMuted,
                            size: 20.sp,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        validator: _validateEmail,
                      ),

                      SizedBox(height: 4.h),

                      // Password Field
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: true,
                        style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.textMuted,
                          ),
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textMuted.withOpacity(0.6),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: BorderSide(color: AppColors.primary, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: BorderSide(color: AppColors.danger),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: BorderSide(color: AppColors.danger, width: 2),
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outlined,
                            color: AppColors.textMuted,
                            size: 20.sp,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        validator: _validatePass,
                      ),

                      SizedBox(height: 4.h),

                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Remember Me
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (v) =>
                                    setState(() => _rememberMe = v ?? false),
                                activeColor: AppColors.primary,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              Text(
                                'Remember me',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          
                          // Forgot Password
                          TextButton(
                            onPressed: _onForgotPassword,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 6.h),

                      // Main Sign In Button
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
                            shadowColor: AppColors.primary.withOpacity(0.3),
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

                      // Create Account Button
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
                            shadowColor: AppColors.success.withOpacity(0.3),
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

                      SizedBox(height: 4.h),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade400,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              'or continue with',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade400,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),

                      // Continue to App Button
                      SizedBox(
                        width: double.infinity,
                        height: 7.h,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const MainNavigationScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.w),
                            ),
                            side: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.rocket_launch, 
                                  color: AppColors.primary, size: 16.sp),
                              SizedBox(width: 3.w),
                              Text(
                                'Explore App Features',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Testing Phase Notice
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2.w),
                          border: Border.all(
                            color: AppColors.warning.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline, 
                                color: AppColors.warning, size: 14.sp),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                "App in testing phase - Use any email & password (min 4 chars)",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.warning,
                                  fontSize: 10.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Spacing
              SizedBox(height: 8.h),

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
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 10.sp,
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