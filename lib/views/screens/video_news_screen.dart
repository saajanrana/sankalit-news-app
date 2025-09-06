import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:Sankalit/services/api_services.dart';
import 'package:Sankalit/views/screens/main_screen.dart';
import 'package:Sankalit/views/widgets/common_header.dart';
import 'package:Sankalit/views/widgets/common_share_url_model.dart';
import 'package:Sankalit/views/widgets/no_data_found_screen.dart';
import 'package:Sankalit/views/widgets/no_internet.dart';
import 'package:Sankalit/views/widgets/video_screen_widgets/video_news_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  bool isDataLoading = true;
  var Url;

  @override
  void initState() {
    super.initState();
    _loadVideoNews();
    Url = dotenv.env['URL'];

    // 👇 Attach scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !isLoadingMore && hasMoreData) {
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
      if (response.containsKey("noInternet") &&
          response["noInternet"] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NoInternetWidget(
              onRetry: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MainScreen(initialIndex: 2,)), 
                );
              },
            ),
          ),
        );
        return;
      }

      if (response['Video News']['success']) {
        final List<dynamic> newData = response['Video News']['data'];
        setState(() {
          if (isRefresh) {
            videoNews = newData; // replace data on refresh
            isDataLoading = false;
          } else {
            videoNews.addAll(newData); // append data for pagination
            isDataLoading = false;
          }

          // if no more data returned
          if (newData.isEmpty) {
            hasMoreData = false;
            isDataLoading = false;
          }
        });
      } else {
        setState(() {
          isDataLoading = false;
        });
        print("something went wrong");
      }
    } catch (e) {
      setState(() {
        isDataLoading = false;
      });
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
                SizedBox(height: 40.h),
                const CommonHeader(),
                SizedBox(height: 20.h),
                Text("WATCH", style: AppTextStyles.heading2.copyWith(color: AppTheme.primaryColor)),
                SizedBox(height: 10.h),

                // News List
                isDataLoading
                    ? Expanded(
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
                    : videoNews.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.zero,
                              itemCount: videoNews.length + (isLoadingMore ? 1 : 0),
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
                                      onPressShareBtn: () {
                                        String slug = item!['slug_title'] ?? '';
                                        String formattedSlug = slug.replaceAll(" ", "_");
                                        showShareModal(context, '$Url/${item['id'] ?? 0}/$formattedSlug');
                                      },
                                    ),
                                  );
                                } else {
                                  // Pagination loader
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20.h),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          )
                        : const NoDataFoundScreen()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
