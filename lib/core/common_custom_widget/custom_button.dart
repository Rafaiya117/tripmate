import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final double height;
  final double borderRadius;
  final FontWeight fontWeight;
  final double fontSize;
  final String? iconPath;
  final Color? borderColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    this.width = 351,
    this.height = 52,
    this.borderRadius = 8,
    this.fontWeight = FontWeight.w700,
    this.fontSize = 16,
    this.iconPath,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1)
                : BorderSide.none,
          ),
          minimumSize: Size(width.w, height.h),
        ),
        child: iconPath == null
            ? Text(
                text,
                style: GoogleFonts.inter(
                  fontWeight: fontWeight,
                  fontSize: fontSize.sp,
                  letterSpacing: 0,
                  color: textColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(iconPath!, height: 26.h, width: 26.w),
                  SizedBox(width: 8.w),
                  Text(
                    text,
                    style: GoogleFonts.inter(
                      fontWeight: fontWeight,
                      fontSize: fontSize.sp,
                      letterSpacing: 0,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
