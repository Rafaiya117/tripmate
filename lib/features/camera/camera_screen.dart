import 'dart:async';
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
import 'package:camera/camera.dart' as camera_package;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  Timer? _analyzingTimer;
  int _analyzingTime = 25;

  @override
  void initState() {
    super.initState();
    // Initialize camera when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripMateCameraController>().initializeCamera();
    });
  }

  @override
  void dispose() {
    _analyzingTimer?.cancel();
    super.dispose();
  }

  void _startAnalyzingTimer() {
    _analyzingTime = 25;
    _analyzingTimer?.cancel();
    _analyzingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_analyzingTime > 0) {
            _analyzingTime--;
          } else {
            timer.cancel();
            // Reset analyzing state when timer completes
            context.read<TripMateCameraController>().stopAnalyzing();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CameraUIController, TripMateCameraController>(
      builder: (context, uiController, cameraController, child) {
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
                            GestureDetector(
                              onTap: () => _showLanguageDropdown(context, uiController),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      uiController.selectedLanguage,
                                      style: GoogleFonts.inter(
                                        color: AppColors.iconColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        height: 1.20,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 16.sp,
                                      color: AppColors.iconColor,
                                    ),
                                  ],
                                ),
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
                         child: _buildCameraControls(context, cameraController),
                       ),
                     ),
                     
                     // Processing UI - Center of Screen
                     if (cameraController.isCapturing)
                       Positioned.fill(
                         child: Center(
                           child: _buildProcessingUI(context, cameraController),
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

  Widget _buildProcessingUI(BuildContext context, TripMateCameraController cameraController) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Analyzing Button
        Container(
          width: 200.w,
          height: 48.h,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
              side: BorderSide(
                color: const Color(0xFF6B7280),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF6B7280),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
                             Text(
                 'Analyzing ${_analyzingTime}s',
                 style: GoogleFonts.inter(
                   color: const Color(0xFF6B7280),
                   fontSize: 16.sp,
                   fontWeight: FontWeight.w500,
                 ),
               ),
            ],
          ),
        ),
        
        SizedBox(height: 16.h),
        
                 // Boost Button
         GestureDetector(
           onTap: () {
             context.push('/booster');
           },
           child: Container(
             width: 200.w,
             height: 48.h,
             decoration: ShapeDecoration(
               color: AppColors.primaryColor,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(24.r),
               ),
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text(
                   'Boost',
                   style: GoogleFonts.inter(
                     color: Colors.white,
                     fontSize: 16.sp,
                     fontWeight: FontWeight.w500,
                   ),
                 ),
                 SizedBox(width: 8.w),
                 Icon(
                   Icons.flash_on,
                   size: 20.sp,
                   color: Colors.white,
                 ),
               ],
             ),
           ),
         ),
      ],
    );
  }

  Widget _buildCameraControls(BuildContext context, TripMateCameraController cameraController) {
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
                         await cameraController.capturePhoto();
                         _startAnalyzingTimer();
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

  void _showLanguageDropdown(BuildContext context, CameraUIController uiController) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
    
    final RelativeRect position = RelativeRect.fromLTRB(
      buttonPosition.dx,
      0,
      overlay.size.width - buttonPosition.dx - button.size.width,
      buttonPosition.dy,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem<String>(
          value: 'English',
          child: Row(
            children: [
              Text(
                'English',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (uiController.selectedLanguage == 'English')
                const Spacer(),
              if (uiController.selectedLanguage == 'English')
                Icon(
                  Icons.check,
                  size: 16.sp,
                  color: AppColors.primaryColor,
                ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '简体中文',
          child: Row(
            children: [
              Text(
                '简体中文',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (uiController.selectedLanguage == '简体中文')
                const Spacer(),
              if (uiController.selectedLanguage == '简体中文')
                Icon(
                  Icons.check,
                  size: 16.sp,
                  color: AppColors.primaryColor,
                ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '繁體中文',
          child: Row(
            children: [
              Text(
                '繁體中文',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (uiController.selectedLanguage == '繁體中文')
                const Spacer(),
              if (uiController.selectedLanguage == '繁體中文')
                Icon(
                  Icons.check,
                  size: 16.sp,
                  color: AppColors.primaryColor,
                ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        uiController.setLanguage(value);
      }
    });
  }
}
