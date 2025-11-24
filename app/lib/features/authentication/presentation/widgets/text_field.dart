import 'dart:core';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/common/text_styles.dart';

/// ===========================================================================
/// CUSTOM TEXT FIELD COMPONENT
/// ===========================================================================
/// 
/// PURPOSE:
/// - Reusable text input field with consistent styling
/// - Supports various input types (text, password, email)
/// - Provides validation and error display
/// - Consistent theming across the application
/// 
/// FEATURES:
/// - Customizable label, hint text, and icon
/// - Password visibility toggle support
/// - Form validation integration
/// - Responsive design using Sizer package
/// - Consistent border styling and focus states
/// ===========================================================================

class MyTextField extends StatefulWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.icon,
    this.validator,
    this.isPass,
  });
  
  // Text editing controller
  final TextEditingController controller;
  
  // Field configuration
  final String labelText;
  final String hintText;
  final Icon icon;
  final String? Function(String?)? validator;
  final bool? isPass;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPass ?? false,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          fontSize: 14.sp,
          color: AppColors.textMuted,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textMuted.withValues(alpha: 0.6),
        ),
        // Border states for different interaction modes
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
        prefixIcon: widget.icon,
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: widget.validator,
    );
  }
}