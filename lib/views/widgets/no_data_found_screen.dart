import 'package:sankalit/core/app_text_style.dart';
import 'package:sankalit/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoDataFoundScreen extends StatelessWidget {
  const NoDataFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.find_in_page_outlined, size: 40.sp),
            SizedBox(height: 16.h),
            const Text(AppStrings.noDataFound, style: AppTextStyles.heading1),
            SizedBox(height: 5.h),
            const Text("There is no Data to show you right now.", style: AppTextStyles.heading3),
          ],
        ),
      ),
    );
    ;
  }
}
