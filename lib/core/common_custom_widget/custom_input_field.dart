import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_mate/config/theme.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final bool obscureText; 
  final VoidCallback? onToggleVisibility; 

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 18.sp,
            letterSpacing: 0,
            color: AppColors.labelTextColor,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 41.h,   
          width: 351.w, 
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? obscureText : false,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: hintText,
              labelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                letterSpacing: 0,
                color: AppColors.textColor1,
              ),
              contentPadding: const EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide.none,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      onPressed: onToggleVisibility,
                      icon: Icon(
                        obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
