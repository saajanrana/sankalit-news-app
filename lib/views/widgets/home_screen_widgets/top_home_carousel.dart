import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';
import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/theme.dart';

class BreakingNewsTicker extends StatelessWidget {
  final String breakingText;
  final String newsText;

  const BreakingNewsTicker({
    Key? key,
    required this.breakingText,
    required this.newsText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Row(
        children: [
          // Left Black Box for "Breaking"
          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            alignment: Alignment.center,
            child: Text(
              breakingText,
              style: AppTextStyles.heading3.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightBackgroundColor,
              ),
            ),
          ),

          // Right Red Box for scrolling text
          Expanded(
            child: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              child: Marquee(
                text: newsText,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightBackgroundColor,
                ),
                scrollAxis: Axis.horizontal,
                blankSpace: 50.w,
                velocity: 40.0, // speed
                pauseAfterRound: Duration(seconds: 0),
                startPadding: 10.w,
                accelerationDuration: Duration(seconds: 2),
                accelerationCurve: Curves.linear,
                decelerationDuration: Duration(milliseconds: 900),
                decelerationCurve: Curves.easeOut,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
