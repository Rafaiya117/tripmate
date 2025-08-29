import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/config/theme.dart';
import 'package:trip_mate/core/common_custom_widget/custom_button.dart';
import 'package:trip_mate/core/common_custom_widget/custom_input_field.dart';
import 'package:trip_mate/features/auths/controllers/ui_controller.dart';
import 'package:trip_mate/features/auths/controllers/auth_controller.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UIController, AuthController>(
      builder: (context, uiController, authController, child) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor2,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            toolbarHeight: 40.h,
            automaticallyImplyLeading: false,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.textColor1,
                size: 24.sp,
              ),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0.h, horizontal: 13.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forgot password',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 22.sp,
                        letterSpacing: 0,
                        color: AppColors.textColor1,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomInputField(
                      label: "Enter valid email",
                      hintText: "example@mail.com",
                      controller: uiController.emailController,
                    ),
                    SizedBox(height: 30.h),
                    
                    // Error Message
                    if (authController.errorMessage != null)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Text(
                          authController.errorMessage!,
                          style: GoogleFonts.inter(
                            color: Colors.red,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    
                    CustomButton(
                      text: authController.isLoading ? "Sending..." : "Continue",
                      onPressed: authController.isLoading
                          ? null
                          : () async {
                              final success = await authController.forgotPassword(
                                uiController.emailController.text,
                              );
                              if (success) {
                                // Navigate to OTP screen
                                context.push('/otp_verification');
                              }
                            },
                      backgroundColor: AppColors.primaryColors,
                      textColor: Colors.white,
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: AppColors.disabled3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Or continue with"),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: AppColors.disabled3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      text: "Google",
                      onPressed: () {},
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      iconPath: AppAssets.googleIcon,
                      borderColor: Colors.black,
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            letterSpacing: 1,
                            color: AppColors.textColor1,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign up',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                letterSpacing: 1,
                                color: AppColors.primaryColors,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push('/sign_up');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
