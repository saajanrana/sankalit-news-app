import 'package:sankalit/controller/book_mark_notifier.dart';
import 'package:sankalit/core/app_text_style.dart';
import 'package:sankalit/core/theme.dart';
import 'package:sankalit/views/widgets/common_widgets/horizontal_line_widget.dart';
import 'package:sankalit/views/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class VideoNewsCard extends ConsumerStatefulWidget {
  final String? videoUrl;
  final int? id;
  final String? videoNewsTitle;
  final String? dateString;
  final VoidCallback? onPressShareBtn;

  const VideoNewsCard({
    super.key,
    required this.id,
    required this.videoUrl,
    required this.dateString,
    required this.videoNewsTitle,
    required this.onPressShareBtn,
  });

  @override
  ConsumerState<VideoNewsCard> createState() => _VideoNewsCardState();
}

class _VideoNewsCardState extends ConsumerState<VideoNewsCard> {
  @override
  Widget build(BuildContext context) {
    final bookmarks = ref.watch(newsBookmarkProvider);

    final isBookmarked = widget.id != null && bookmarks.contains(widget.id);

    final bool isLoading = widget.videoUrl == null || widget.videoNewsTitle == null || widget.dateString == null;

    if (isLoading) {
      return _buildShimmer();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VideoPlayerWidget(videoUrl: widget.videoUrl!),
        SizedBox(height: 10.h),
        Text(widget.videoNewsTitle!, style: AppTextStyles.bodyBoldHindi),
        SizedBox(height: 5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.dateString!, style: AppTextStyles.small),
            Row(
              children: [
                InkWell(
                  onTap: widget.onPressShareBtn,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.darkBackgroundColor,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                    child: Text(
                      "SHARE",
                      style: AppTextStyles.small.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightBackgroundColor,
                      ),
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
                      if (widget.id != null) {
                        ref.read(newsBookmarkProvider.notifier).toggleBookmark(widget.id!);
                      }
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

  /// ✅ Shimmer widget when data is loading
  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200.h,
            width: double.infinity,
            color: Colors.white,
          ),
          SizedBox(height: 10.h),
          Container(height: 20.h, width: 200.w, color: Colors.white),
          SizedBox(height: 5.h),
          Container(height: 15.h, width: 100.w, color: Colors.white),
          SizedBox(height: 10.h),
          Row(
            children: [
              Container(height: 30.h, width: 60.w, color: Colors.white),
              SizedBox(width: 10.w),
              Container(height: 30.h, width: 30.w, color: Colors.white),
            ],
          ),
          SizedBox(height: 10.h),
          Container(height: 1.h, width: double.infinity, color: Colors.white),
        ],
      ),
    );
  }
}
