import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsCardShimmer extends StatelessWidget {
  const NewsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 170.h,
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            // Left shimmer box for image
            Container(
              width: 140.w,
              height: 150.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(width: 12.w),
            // Right shimmer placeholders for text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: 20.h, width: double.infinity, color: Colors.white),
                  SizedBox(height: 8.h),
                  Container(height: 15.h, width: 200.w, color: Colors.white),
                  SizedBox(height: 8.h),
                  Container(height: 15.h, width: 180.w, color: Colors.white),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(height: 15.h, width: 100.w, color: Colors.white),
                      Container(height: 30.h, width: 30.w, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
