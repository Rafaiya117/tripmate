import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_mate/config/colors/colors.dart';
import 'package:trip_mate/features/history/controllers/history_controller.dart';
import 'package:trip_mate/features/history/widgets/history_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor2,
      body: Consumer<HistoryController>(
        builder: (context, historyController, child) {
          return SafeArea(
            child: Column(
              children: [
                // App Bar
                _buildAppBar(context, historyController),
                
                // Search and Filter Bar
                _buildSearchBar(context, historyController),
                
                // Content
                Expanded(
                  child: _buildContent(context, historyController),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, HistoryController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                // color: AppColors.disabled2,
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
              'History',
              style: GoogleFonts.inter(
                color: AppColors.textColor1,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          SizedBox(width: 16.w),
          
          // Profile Button
          // Container(
          //   width: 24.w,
          //   height: 24.w,
          //   decoration: BoxDecoration(
          //     color: AppColors.disabled2,
          //     borderRadius: BorderRadius.circular(4.r),
          //   ),
          //   child: Icon(
          //     Icons.person,
          //     size: 16.sp,
          //     color: AppColors.iconColor,
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              context.push('/profile');
            },
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.iconColor, width: 2),
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 16.sp,
                  color: AppColors.iconColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, HistoryController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          // Search Icon
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              // color: AppColors.disabled2,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(
              Icons.search,
              size: 14.sp,
              color: AppColors.iconColor,
            ),
          ),
          
          SizedBox(width: 8.w),
          
          // Search TextField
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: controller.searchHistory,
              decoration: InputDecoration(
                hintText: 'Search history...',
                hintStyle: GoogleFonts.inter(
                  color: AppColors.labelTextColor,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8.h),
              ),
              style: GoogleFonts.inter(
                color: AppColors.textColor1,
                fontSize: 14.sp,
              ),
            ),
          ),
          
          SizedBox(width: 8.w),
          
          // Filter Icon with Dropdown
          PopupMenuButton<String>(
            icon: Container(
              width: 20.w,
              height: 18.w,
              decoration: BoxDecoration(
                // color: AppColors.disabled2,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Icon(
                Icons.filter_list,
                size: 14.sp,
                color: AppColors.iconColor,
              ),
            ),
            onSelected: (value) => _applyFilter(controller, value),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'week',
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18.sp,
                      color: AppColors.iconColor,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Last week',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.textColor1,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'month',
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 18.sp,
                      color: AppColors.iconColor,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Last month',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.textColor1,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'year',
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_view_month,
                      size: 18.sp,
                      color: AppColors.iconColor,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Last year',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.textColor1,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(
                      Icons.clear,
                      size: 18.sp,
                      color: Colors.red,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Clear filter',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 8,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, HistoryController controller) {
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
              onPressed: controller.refreshHistory,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (controller.filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 48.sp,
              color: AppColors.disabled1,
            ),
            SizedBox(height: 16.h),
            Text(
              controller.searchQuery.isEmpty 
                ? 'No history found'
                : 'No results found for "${controller.searchQuery}"',
              style: GoogleFonts.inter(
                color: AppColors.disabled1,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
            if (controller.searchQuery.isNotEmpty) ...[
              SizedBox(height: 16.h),
              TextButton(
                onPressed: controller.clearSearch,
                child: Text('Clear search'),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshHistory,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        itemCount: controller.filteredList.length,
        itemBuilder: (context, index) {
          final history = controller.filteredList[index];
          return HistoryCard(
            history: history,
            onDelete: () => _showDeleteDialog(context, controller, history.id),
            onTap: () => _onHistoryTap(context, history),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, HistoryController controller, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete History',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this history item?',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteHistoryItem(id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('History item deleted'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onHistoryTap(BuildContext context, history) {
    // Navigate to history details screen
    context.push('/history/${history.id}');
  }

  void _applyFilter(HistoryController controller, String filterType) {
    switch (filterType) {
      case 'week':
        controller.filterByTime('week');
        break;
      case 'month':
        controller.filterByTime('month');
        break;
      case 'year':
        controller.filterByTime('year');
        break;
      case 'clear':
        controller.clearTimeFilter();
        break;
    }
  }
}
