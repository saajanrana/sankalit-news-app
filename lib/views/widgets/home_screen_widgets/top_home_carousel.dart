import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';

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
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            alignment: Alignment.center,
            child: Text(
              breakingText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                scrollAxis: Axis.horizontal,
                blankSpace: 50.w,
                velocity: 40.0, // speed
                pauseAfterRound: Duration(seconds: 1),
                startPadding: 10.w,
                accelerationDuration: Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
