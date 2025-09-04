import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:Sankalit/services/api_services.dart';
import 'package:Sankalit/views/widgets/common_header.dart';
import 'package:Sankalit/views/widgets/video_screen_widgets/video_news_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class VideoNewsScreen extends StatefulWidget {
  const VideoNewsScreen({super.key});

  @override
  State<VideoNewsScreen> createState() => _VideoNewsScreenState();
}

class _VideoNewsScreenState extends State<VideoNewsScreen> {
  List<dynamic> videoNews = [];
  int page = 1;
  bool isLoadingMore = false;
  bool hasMoreData = true; // flag to stop API calls if no more data

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadVideoNews();

    // 👇 Attach scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore &&
          hasMoreData) {
        _loadMoreNews();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadVideoNews({bool isRefresh = false}) async {
    try {
      final response = await ApiServices.get(endpoint: "video-news?page=$page");
      print("response::::::${response['Video News']}");

      if (response['Video News']['success']) {
        final List<dynamic> newData = response['Video News']['data'];

        setState(() {
          if (isRefresh) {
            videoNews = newData; // replace data on refresh
          } else {
            videoNews.addAll(newData); // append data for pagination
          }

          // if no more data returned
          if (newData.isEmpty) {
            hasMoreData = false;
          }
        });
      } else {
        print("something went wrong");
      }
    } catch (e) {
      print("Error in loadVideoNews:::::$e");
    }
  }

  Future<void> _loadMoreNews() async {
    setState(() => isLoadingMore = true);

    page++; // ✅ Increment page
    await _loadVideoNews();

    setState(() => isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          page = 1;
          hasMoreData = true;
          await _loadVideoNews(isRefresh: true);
        },
        color: AppTheme.primaryColor,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppTheme.lightBackgroundColor,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                const CommonHeader(),
                SizedBox(height: 20.h),
                Text("WATCH",
                    style: AppTextStyles.heading2
                        .copyWith(color: AppTheme.primaryColor)),
                SizedBox(height: 10.h),

                // News List
                videoNews.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.zero,
                          itemCount:
                              videoNews.length + (isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < videoNews.length) {
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
                            } else {
                              // Pagination loader
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: Container(
                                        height: 200.h,
                                        width: double.infinity,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: Container(
                                        height: 16.h,
                                        width: 200.w,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: Container(
                                        height: 14.h,
                                        width: 100.w,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
