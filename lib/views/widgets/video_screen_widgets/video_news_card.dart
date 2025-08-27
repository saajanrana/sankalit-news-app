import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/app_text_style.dart';
import 'package:news_app/core/theme.dart';
import 'package:news_app/views/widgets/common_widgets/horizontal_line_widget.dart';
import 'package:news_app/views/widgets/video_player_widget.dart';

class VideoNewsCard extends StatelessWidget {
  final String videoUrl;
  final String videoNewsTitle;
  final String dateString;
  final VoidCallback onPressShareBtn;
  final VoidCallback onPressSaveBtn;

  const VideoNewsCard({super.key, required this.videoUrl, required this.dateString, required this.videoNewsTitle, required this.onPressSaveBtn, required this.onPressShareBtn});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VideoPlayerWidget(videoUrl: videoUrl),
        SizedBox(height: 10.h),
        Text(videoNewsTitle, style: AppTextStyles.bodyBoldHindi),
        SizedBox(height: 5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(dateString, style: AppTextStyles.small),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: onPressShareBtn,
                  child: Container(
                    decoration: BoxDecoration(color: AppTheme.darkBackgroundColor, borderRadius: BorderRadius.circular(5.r)),
                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                    alignment: Alignment.center,
                    child: Text(
                      "SHARE",
                      style: AppTextStyles.small.copyWith(fontWeight: FontWeight.bold, color: AppTheme.lightBackgroundColor),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                InkWell(
                  onTap: onPressSaveBtn,
                  child: Icon(
                    Icons.bookmark,
                    size: 20.sp,
                  ),
                )
              ],
            )
          ],
        ),
        SizedBox(height: 5.h),
        const HorizontalLineWidget()
      ],
    );
  }
}
