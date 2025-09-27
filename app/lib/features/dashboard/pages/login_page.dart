import 'package:app/features/dashboard/pages/user_progress_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(5.w), // 5% del ancho de pantalla
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5.h), // 5% de la altura de pantalla
              
              // Header
              Text(
                'Welcome Back',
                style: AppTextStyles.welcomeTitle.copyWith(
                  fontSize: 18.sp, // 18 unidades responsive
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Sign in to continue your learning journey',
                style: AppTextStyles.welcomeSubtitle.copyWith(
                  fontSize: 12.sp,
                ),
              ),
              
              SizedBox(height: 6.h),
              
              // Login Form
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(3.w),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 4.w,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Email Field
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12.sp,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.w),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.w),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        prefixIcon: Icon(Icons.email_outlined, 
                            color: AppColors.textMuted, size: 18.sp),
                      ),
                    ),
                    
                    SizedBox(height: 3.h),
                    
                    // Password Field
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12.sp,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.w),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.w),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        prefixIcon: Icon(Icons.lock_outlined, 
                            color: AppColors.textMuted, size: 18.sp),
                      ),
                    ),
                    
                    SizedBox(height: 3.h),
                    
                    // Remember Me & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (value) {},
                              activeColor: AppColors.primary,
                            ),
                            Text(
                              'Remember me',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 4.h),
                    
                    // Sign In Button (Disabled)
                    SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 2.h),
                    
                    // Create Account Button (Disabled)
                    SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                        child: Text(
                          'Create Account',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 3.h),
                    
                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey.shade300),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            'or',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey.shade300),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 3.h),
                    
                    // Continue to App Button
                    SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const UserProgressDashboard(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                          side: BorderSide(color: AppColors.primary),
                        ),
                        child: Text(
                          'Continue to App',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 3.h),
                    
                    // Footer text
                    Text(
                      "App in testing phase",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }
}