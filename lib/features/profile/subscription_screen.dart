import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/config/colors/colors.dart';
import 'package:trip_mate/features/profile/controllers/subscription_controller.dart';
import 'package:trip_mate/features/profile/widgets/subscription_button.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor2,
          body: _buildBody(context, controller),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SubscriptionController controller) {
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.sp,
              color: AppColors.disabled1,
            ),
            SizedBox(height: 16.h),
            Text(
              controller.errorMessage!,
              style: GoogleFonts.inter(
                color: AppColors.disabled1,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: controller.refreshSubscription,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    final subscription = controller.subscription;
    if (subscription == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SafeArea(
      child: Column(
        children: [
          // App Bar
          _buildAppBar(context),
          
          // Content
          Expanded(
            child: _buildContent(context, subscription, controller),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                // color: AppColors.disabled1,
                color: Colors.transparent,
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
              'Subscription',
              style: GoogleFonts.inter(
                color: AppColors.textColor1,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          SizedBox(width: 42.w),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, subscription, SubscriptionController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          
          // Plan Status Text
          SizedBox(
            width: double.infinity,
            child: Text(
              'You\'re enjoying the ${subscription.planName}.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppColors.textColor1,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                height: 1.69,
                letterSpacing: 0.64,
              ),
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // Upgrade Message
          SizedBox(
            width: double.infinity,
            child: Text(
              'Want more? Upgrade now for unlimited access anytime.',
              style: GoogleFonts.inter(
                color: AppColors.textColor1,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 2.25,
                letterSpacing: 0.48,
              ),
            ),
          ),
          
          SizedBox(height: 25.h),
          
          // Upgrade Button
          SubscriptionButton(
            text: 'Upgrade plan',
            onPressed: subscription.canUpgrade 
              ? () => _handleUpgrade(context, controller)
              : null,
            isLoading: controller.isUpgrading,
            isPrimary: true,
          ),
          
          SizedBox(height: 16.h),
          
          // Cancel Button
          SubscriptionButton(
            text: 'Cancel subscription',
            onPressed: subscription.canCancel 
              ? () => _handleCancel(context, controller)
              : null,
            isLoading: controller.isCancelling,
            isPrimary: false,
            icon: Icons.close,
          ),
        ],
      ),
    );
  }

  void _handleUpgrade(BuildContext context, SubscriptionController controller) async {
    final success = await controller.upgradeSubscription();
    if (success) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Subscription upgraded successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upgrade subscription. Please try again.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _handleCancel(BuildContext context, SubscriptionController controller) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
          return Dialog(
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(4.r),
           ),
           child: Container(
             width: 340.w,
             constraints: BoxConstraints(
               minHeight: 173.h,
               maxHeight: 200.h,
             ),
             decoration: ShapeDecoration(
               color: Colors.white,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(4.r),
               ),
             ),
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 // Header with separator
                 Container(
                   padding: EdgeInsets.all(16.w),
                   decoration: BoxDecoration(
                     border: Border(
                       bottom: BorderSide(
                         color: AppColors.disabled2,
                         width: 1,
                       ),
                     ),
                   ),
                   child: Row(
                     children: [
                       Container(
                         width: 24.w,
                         height: 24.w,
                         decoration: BoxDecoration(
                           color: const Color(0xFFF74747),
                           shape: BoxShape.circle,
                         ),
                         child: Icon(
                           Icons.close,
                           size: 16.sp,
                           color: Colors.white,
                         ),
                       ),
                       SizedBox(width: 12.w),
                       Expanded(
                         child: Text(
                           'Delete subscription',
                           style: GoogleFonts.inter(
                             color: AppColors.textColor1,
                             fontSize: 18.sp,
                             fontWeight: FontWeight.w600,
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
                 
                 // Content
                 Flexible(
                   child: Padding(
                     padding: EdgeInsets.all(16.w),
                     child: Center(
                       child: Text(
                         'Are you sure you want to delete this subscription?',
                         style: GoogleFonts.inter(
                           color: AppColors.labelTextColor,
                           fontSize: 16.sp,
                           fontWeight: FontWeight.w400,
                         ),
                         textAlign: TextAlign.center,
                       ),
                     ),
                   ),
                 ),
                
                // Action Buttons
                Container(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color: AppColors.disabled2,
                              width: 1,
                            ),
                          ),
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.inter(
                                color: AppColors.textColor1,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(width: 12.w),
                      
                      // Delete Button
                      Expanded(
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF74747),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              final success = await controller.cancelSubscription();
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Subscription cancelled successfully.'),
                                    backgroundColor: Colors.green,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              } else if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to cancel subscription. Please try again.'),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            child: Text(
                              'Delete',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
