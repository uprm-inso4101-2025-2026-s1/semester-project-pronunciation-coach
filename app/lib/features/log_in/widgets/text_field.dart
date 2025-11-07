import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';

class myTextField extends StatefulWidget {
  const myTextField({super.key, required this.controller, required this.labelText, required this.hintText, required this.icon, this.validator, this.isPass});
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Icon icon;
  final String?Function(String?)? validator;
  final bool? isPass;

  @override
  State<myTextField> createState() => _myTextFieldState();
}

class _myTextFieldState extends State<myTextField> {
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
        prefixIcon: widget.icon,
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: widget.validator,
    );
  }
}