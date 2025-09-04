import 'package:Sankalit/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:Sankalit/views/widgets/common_header.dart';
import 'package:Sankalit/views/widgets/video_screen_widgets/video_news_card.dart';

import '../../models/video_news_model.dart';

class VideoNewsScreen extends StatefulWidget {
  const VideoNewsScreen({super.key});

  @override
  State<VideoNewsScreen> createState() => _VideoNewsScreenState();
}

class _VideoNewsScreenState extends State<VideoNewsScreen> {
  List<dynamic> videoNews = [];

  @override
  void initState() {
    super.initState();
    _loadVideoNews();
  }

  void _loadVideoNews() async {
    try {
      final response = await ApiServices.get(endpoint: "video-news");
      print("response::::::${response['Video News']}");
      // if (response['noInternet']) {
      //   return;
      // }
      if (response['Video News']['success']) {
        setState(() {
          videoNews = response['Video News']['data'];
        });
      } else {
        print("something went wrong");
      }
    } catch (e) {
      print("Error in loadVideoNews:::::$e");
    }
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
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),
                  const CommonHeader(),
                  SizedBox(height: 20.h),
                  Text(
                    "WATCH",
                    style: AppTextStyles.heading2.copyWith(color: AppTheme.primaryColor),
                  ),
                  SizedBox(height: 10.h),
                  videoNews.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                          padding: EdgeInsets.all(0.sp),
                          scrollDirection: Axis.vertical,
                          itemCount: videoNews.length,
                          itemBuilder: (context, index) {
                            final item = videoNews[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: VideoNewsCard(
                                id: item['id'],
                                videoUrl: item['video_link'],
                                videoNewsTitle: item['title'].toString(),
                                dateString: item['created_on'],
                                onPressSaveBtn: () {},
                                onPressShareBtn: () {},
                              ),
                            );
                          },
                        ))
                      : const SizedBox(
                          child: Text("No Data Found!"),
                        )
                ],
              ),
            ),
          )),
    );
  }
}
