import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/config/colors/colors.dart';
import 'package:trip_mate/features/profile/controllers/edit_profile_controller.dart';
import 'package:trip_mate/features/profile/widgets/custom_text_field.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor2,
          body: _buildBody(context, controller),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, EditProfileController controller) {
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                // App Bar
                _buildAppBar(context),
                
                SizedBox(height: 40.h),
                
                // Profile Image Section
                _buildProfileImageSection(),
                
                SizedBox(height: 40.h),
                
                // Form Fields
                _buildFormFields(controller),
                
                SizedBox(height: 40.h),
                
                // Save Button
                _buildSaveButton(context, controller),
                
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                color: AppColors.disabled1,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Icon(
                Icons.arrow_back,
                size: 18.sp,
                color: AppColors.iconColor,
              ),
            ),
          ),
          
          SizedBox(width: 16.w),
          
          // Title
          Expanded(
            child: Text(
              'Edit profile',
              style: GoogleFonts.inter(
                color: AppColors.textColor1,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          SizedBox(width: 42.w), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Stack(
        children: [
          // Profile Image
          Container(
            width: 94.w,
            height: 94.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryColor,
                width: 3.w,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.disabled1,
                    child: Icon(
                      Icons.person,
                      size: 40.sp,
                      color: AppColors.iconColor,
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Camera Icon Overlay
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: AppColors.primaryColor,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.camera_alt,
                size: 16.sp,
                color: AppColors.iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(EditProfileController controller) {
    return Column(
      children: [
        // Full Name Field
        CustomTextField(
          label: 'Full name',
          controller: controller.fullNameController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
          keyboardType: TextInputType.name,
        ),
        
        SizedBox(height: 24.h),
        
        // Email Field
        CustomTextField(
          label: 'Email address',
          controller: controller.emailController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email address';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
        ),
        
        SizedBox(height: 24.h),
        
        // Old Password Field
        CustomTextField(
          label: 'Old password',
          controller: controller.oldPasswordController,
          isPassword: true,
          isVisible: controller.isOldPasswordVisible,
          onToggleVisibility: controller.toggleOldPasswordVisibility,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your old password';
            }
            return null;
          },
        ),
        
        SizedBox(height: 24.h),
        
        // New Password Field
        CustomTextField(
          label: 'New password',
          controller: controller.newPasswordController,
          isPassword: true,
          isVisible: controller.isNewPasswordVisible,
          onToggleVisibility: controller.toggleNewPasswordVisibility,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your new password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, EditProfileController controller) {
    return Container(
      width: double.infinity,
      height: 52.h,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: controller.isSaving ? null : () => _handleSave(context, controller),
          child: Center(
            child: controller.isSaving
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Save',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.20,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave(BuildContext context, EditProfileController controller) async {
    final success = await controller.saveProfile();
    
    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.successMessage!),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Navigate back after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage!),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
