import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/app_text_style.dart';
import 'package:news_app/core/theme.dart';
import 'package:news_app/views/widgets/common_header.dart';
import 'package:news_app/views/widgets/video_screen_widgets/video_news_card.dart';

import '../../models/video_news_model.dart';

class VideoNewsScreen extends StatefulWidget {
  const VideoNewsScreen({super.key});

  @override
  State<VideoNewsScreen> createState() => _VideoNewsScreenState();
}

class _VideoNewsScreenState extends State<VideoNewsScreen> {
  List<VideoNewsModel> videoNews = [];

  @override
  void initState() {
    super.initState();
    _loadVideoNews();
  }

  void _loadVideoNews() {
    setState(() {
      videoNews = VideoNewsModel.getMockVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            _loadVideoNews();
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppTheme.lightBackgroundColor,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  const CommonHeader(),
                  SizedBox(height: 20.h),
                  Text(
                    "WATCH",
                    style: AppTextStyles.heading2.copyWith(color: AppTheme.primaryColor),
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                      child: ListView.builder(
                    padding: EdgeInsets.all(0.sp),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: VideoNewsCard(
                          videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
                          videoNewsTitle: "बागेश्वर के हरबाड़ में भारी बारिश और भूस्खलन से तबाही, कई घर क्षतिग्रस्त",
                          dateString: "19-05-2025",
                          onPressSaveBtn: () {},
                          onPressShareBtn: () {},
                        ),
                      );
                    },
                  ))
                ],
              ),
            ),
          )),
    );
  }
}
