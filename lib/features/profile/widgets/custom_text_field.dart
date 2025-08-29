import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_mate/config/colors/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool isVisible;
  final VoidCallback? onToggleVisibility;
  final TextInputType? keyboardType;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.isPassword = false,
    this.isVisible = false,
    this.onToggleVisibility,
    this.keyboardType,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.labelTextColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8.h),
        
        // Text Field
        Container(
          width: double.infinity,
          height: 41.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            obscureText: isPassword && !isVisible,
            keyboardType: keyboardType,
            enabled: enabled,
            style: GoogleFonts.inter(
              color: enabled ? AppColors.textColor1 : AppColors.labelTextColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 10.h,
              ),
              border: InputBorder.none,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.iconColor,
                        size: 20.sp,
                      ),
                      onPressed: onToggleVisibility,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
