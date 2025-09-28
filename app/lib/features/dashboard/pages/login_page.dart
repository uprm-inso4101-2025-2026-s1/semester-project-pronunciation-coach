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
                  fontSize: 24.sp, // Increased from 18.sp to 24.sp
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Sign in to continue your learning journey',
                style: AppTextStyles.welcomeSubtitle.copyWith(
                  fontSize: 16.sp, // Increased from 12.sp to 16.sp
                ),
              ),
              
              SizedBox(height: 8.h),
              
              // Login Form
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(6.w), // Increased padding
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
                      style: TextStyle(fontSize: 14.sp), // Added text size
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 14.sp, // Increased from 12.sp to 14.sp
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
                            color: AppColors.textMuted, size: 20.sp), // Increased icon size
                      ),
                    ),
                    
                    SizedBox(height: 4.h),
                    
                    // Password Field
                    TextField(
                      obscureText: true,
                      style: TextStyle(fontSize: 14.sp), // Added text size
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 14.sp, // Increased from 12.sp to 14.sp
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
                            color: AppColors.textMuted, size: 20.sp), // Increased icon size
                      ),
                    ),
                    
                    SizedBox(height: 4.h),
                    
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
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            Text(
                              'Remember me',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 12.sp, // Increased from 10.sp to 12.sp
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
                              fontSize: 12.sp, // Increased from 10.sp to 12.sp
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 5.h),
                    
                    // Sign In Button (Disabled)
                    SizedBox(
                      width: double.infinity,
                      height: 7.h, // Increased height
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
                            fontSize: 16.sp, // Increased from 14.sp to 16.sp
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 3.h),
                    
                    // Create Account Button (Disabled)
                    SizedBox(
                      width: double.infinity,
                      height: 7.h, // Increased height
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
                            fontSize: 16.sp, // Increased from 14.sp to 16.sp
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 4.h),
                    
                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey.shade300, thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            'or',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 12.sp, // Increased from 10.sp to 12.sp
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey.shade300, thickness: 1),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 4.h),
                    
                    // Continue to App Button
                    SizedBox(
                      width: double.infinity,
                      height: 7.h, // Increased height
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
                          side: BorderSide(color: AppColors.primary, width: 2),
                        ),
                        child: Text(
                          'Continue to App',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp, // Increased from 12.sp to 14.sp
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 4.h),
                    
                    // Footer text
                    Text(
                      "App in testing phase",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 12.sp, // Increased from 10.sp to 12.sp
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
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