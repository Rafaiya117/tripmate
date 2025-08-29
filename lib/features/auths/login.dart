import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/config/theme.dart';
import 'package:trip_mate/core/common_custom_widget/custom_button.dart';
import 'package:trip_mate/core/common_custom_widget/custom_input_field.dart';
import 'package:trip_mate/core/common_custom_widget/custom_language_dropdown.dart';
import 'package:trip_mate/features/auths/controllers/ui_controller.dart';
import 'package:trip_mate/features/auths/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
            title: Align(
              alignment: Alignment.topRight,
              child: CustomDropdown(
                items: ['Item1', 'Item2', 'Item3', 'Item4'],
                selectedValue: uiController.selectedValue,
                hintText: 'Select Item',
                onChanged: (value) {
                  uiController.setSelectedValue(value);
                },
                buttonWidth: 160,
                buttonHeight: 50,
                itemHeight: 50,
                fontSize: 16,
                textColor: Colors.brown,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.brown),
              ),
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
                      'Sign in',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 22.sp,
                        letterSpacing: 0,
                        color: AppColors.textColor1,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomInputField(
                      label: "Enter email address",
                      hintText: "example@mail.com",
                      controller: uiController.emailController,
                    ),
                    SizedBox(height: 10.h),
                    CustomInputField(
                      label: "Enter password",
                      hintText: "********",
                      controller: uiController.passwordController,
                      isPassword: true,
                      obscureText: uiController.obscurePassword,
                      onToggleVisibility: () {
                        uiController.togglePasswordVisibility();
                      },
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 208),
                      child: Text.rich(
                        TextSpan(
                          text: 'Forgot Password',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            letterSpacing: 2,
                            color: AppColors.primaryColors,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.push('/forgot_password');
                            },
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      text: "Log in",
                      onPressed: () async {
                        final success = await authController.login(
                          uiController.emailController.text,
                          uiController.passwordController.text,
                        );
                        if (success) {
                          // Navigate to camera screen after successful login
                          context.go('/camera');
                        }
                      },
                      backgroundColor: AppColors.primaryColors,
                      textColor: Colors.white,
                    ),
                    SizedBox(height: 10.h),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            letterSpacing: 1,
                            color: Colors.black,
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
                    SizedBox(height: 10.h),
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
                          child: Text("or continue with"),
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