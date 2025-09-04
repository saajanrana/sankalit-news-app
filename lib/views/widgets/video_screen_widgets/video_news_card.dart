import 'package:Sankalit/controller/book_mark_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:Sankalit/views/widgets/common_widgets/horizontal_line_widget.dart';
import 'package:Sankalit/views/widgets/video_player_widget.dart';

class VideoNewsCard extends ConsumerStatefulWidget {
  final String videoUrl;
  final int id;
  final String videoNewsTitle;
  final String dateString;
  final VoidCallback onPressShareBtn;
  final VoidCallback onPressSaveBtn;

  const VideoNewsCard({super.key, required this.id, required this.videoUrl, required this.dateString, required this.videoNewsTitle, required this.onPressSaveBtn, required this.onPressShareBtn});

  @override
  ConsumerState<VideoNewsCard> createState() => _VideoNewsCardState();
}

class _VideoNewsCardState extends ConsumerState<VideoNewsCard> {
  @override
  Widget build(BuildContext context) {
    final bookmarks = ref.watch(newsBookmarkProvider);

    final isBookmarked = bookmarks.contains(widget.id);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VideoPlayerWidget(videoUrl: widget.videoUrl),
        SizedBox(height: 10.h),
        Text(widget.videoNewsTitle, style: AppTextStyles.bodyBoldHindi),
        SizedBox(height: 5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.dateString, style: AppTextStyles.small),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: widget.onPressShareBtn,
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
                Container(
                  width: 32.w,
                  height: 32.h,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Image.asset(
                      isBookmarked ? 'assets/icons/bookmarkActive.png' : 'assets/icons/bookmark.png',
                      width: 24.w,
                      height: 24.h,
                      fit: BoxFit.contain,
                    ),
                    onPressed: () {
                      ref.read(newsBookmarkProvider.notifier).toggleBookmark(widget.id);
                    },
                  ),
                ),
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
