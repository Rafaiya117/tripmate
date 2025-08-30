
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/config/theme.dart';
import 'package:trip_mate/config/colors/colors.dart';
import 'package:trip_mate/features/camera/controllers/camera_controller.dart';
import 'package:trip_mate/features/camera/controllers/ui_controller.dart';
import 'package:trip_mate/core/common_custom_widget/custom_language_dropdown.dart';
import 'package:trip_mate/features/auths/services/auth_service.dart';
import 'package:camera/camera.dart' as camera_package;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize camera when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripMateCameraController>().initializeCamera();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Reset camera state when app becomes active
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<TripMateCameraController>().resetCameraState();
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset camera state when returning to this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TripMateCameraController>().resetCameraState();
      }
    });
  }





  @override
  Widget build(BuildContext context) {
    return Consumer3<CameraUIController, TripMateCameraController, AuthService>(
      builder: (context, uiController, cameraController, authService, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Camera Preview Area - Full Screen
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    // Camera preview
                    if (cameraController.isInitialized && cameraController.cameraController != null)
                      camera_package.CameraPreview(cameraController.cameraController!)
                    else
                      // Camera preview placeholder
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 80.sp,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              SizedBox(height: 16.h),
                              if (cameraController.errorMessage != null)
                                Text(
                                  cameraController.errorMessage!,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              else
                                Text(
                                  'Initializing camera...',
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14.sp,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    
                    // Top Controls
                    Positioned(
                      top: 50.h,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Settings Button
                            Container(
                              width: 24.w,
                              height: 24.w,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.settings,
                                  size: 16.sp,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // Navigate to profile screen
                                  context.push('/profile');
                                },
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            
                            // Language Dropdown
                            CustomDropdown(
                              items: ['English', '简体中文', '繁體中文'],
                              selectedValue: uiController.selectedLanguage,
                              hintText: 'Select Language',
                              onChanged: (value) {
                                if (value != null) {
                                  uiController.setLanguage(value);
                                }
                              },
                              buttonWidth: 120,
                              buttonHeight: 32,
                              itemHeight: 40,
                              fontSize: 12,
                              textColor: AppColors.iconColor,
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 16.sp,
                                color: AppColors.iconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                                         // Bottom Controls
                     Positioned(
                       bottom: 50.h,
                       left: 0,
                       right: 0,
                       child: Padding(
                         padding: EdgeInsets.symmetric(horizontal: 12.w),
                         child: _buildCameraControls(context, cameraController, authService),
                       ),
                     ),
                     
                     
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  

  Widget _buildCameraControls(BuildContext context, TripMateCameraController cameraController, AuthService authService) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Gallery Button
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: IconButton(
            icon: Icon(
              Icons.photo_library,
              size: 18.sp,
              color: Colors.white,
            ),
            onPressed: () {
              cameraController.openGallery();
            },
            padding: EdgeInsets.zero,
          ),
        ),
        
        // Camera Shutter Button
        Center(
          child: Stack(
            children: [
              // Outer ring
              Container(
                width: 64.w,
                height: 64.w,
                decoration: ShapeDecoration(
                  shape: OvalBorder(
                    side: BorderSide(
                      width: 2.w,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Inner button
              Positioned(
                left: 4.w,
                top: 4.w,
                                 child: GestureDetector(
                   onTap: cameraController.isCapturing 
                     ? null 
                                             : () async {
                          // Check if user is authenticated
                          if (!authService.isAuthenticated()) {
                            // Capture photo first
                            await cameraController.capturePhoto();
                            if (cameraController.lastCapturedImage != null) {
                              // Store the captured image path for after login
                              await authService.setPendingImagePath(cameraController.lastCapturedImage!);
                              // Reset camera state
                              cameraController.resetCameraState();
                              // Show login screen
                              context.push('/login_page');
                            }
                            return;
                          }
                          
                          await cameraController.capturePhoto();
                          if (cameraController.lastCapturedImage != null) {
                            // Navigate to image view screen with the captured image
                            context.push('/image_view?imagePath=${Uri.encodeComponent(cameraController.lastCapturedImage!)}');
                            // Reset camera state after navigation
                            cameraController.resetCameraState();
                          }
                        },
                  child: Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: ShapeDecoration(
                      color: cameraController.isCapturing 
                        ? Colors.grey 
                        : Colors.white,
                      shape: const OvalBorder(),
                    ),
                    child: cameraController.isCapturing
                      ? Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.w,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        )
                      : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Recent Button
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: IconButton(
            icon: Icon(
              Icons.history,
              size: 18.sp,
              color: Colors.white,
            ),
            onPressed: () {
              context.push('/history');
            },
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }


}
