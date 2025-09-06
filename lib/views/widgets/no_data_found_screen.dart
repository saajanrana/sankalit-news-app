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
            Icon(
              Icons.article_outlined,
              size: 40.sp,
              color: Colors.grey, // 👈 Grey color added
            ),
            SizedBox(height: 16.h),
            Text(
              AppStrings.noDataFound,
              style: AppTextStyles.heading1.copyWith(
                color: Colors.grey, // 👈 Grey color added
              ),
            ),
            SizedBox(height: 5.h),
            // Text(
            //   "There is no news to show you right now.",
            //   style: AppTextStyles.heading3.copyWith(
            //     color: Colors.grey, // 👈 Grey color added
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
