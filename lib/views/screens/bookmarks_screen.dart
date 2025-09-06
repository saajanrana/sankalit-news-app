import 'package:Sankalit/controller/book_mark_notifier.dart';
import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:Sankalit/services/api_services.dart';
import 'package:Sankalit/viewmodels/news_viewmodel.dart';
import 'package:Sankalit/views/screens/main_screen.dart';
import 'package:Sankalit/views/screens/news_detail_screen.dart';
import 'package:Sankalit/views/widgets/common_header.dart';
import 'package:Sankalit/views/widgets/news_card.dart';
import 'package:Sankalit/views/widgets/no_data_found_screen.dart';
import 'package:Sankalit/views/widgets/no_internet.dart';
import 'package:Sankalit/views/widgets/saved_screen_widgets/saved_news_toggle_btn.dart';
import 'package:Sankalit/views/widgets/shimmer_loading.dart';
import 'package:Sankalit/views/widgets/video_screen_widgets/video_news_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  bool isTextNewsIsSelected = true;
  List<dynamic> savedNewsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSavedNews("Text News");
    });
  }

  String removeHtmlTags(String htmlText) {
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlText
        .replaceAll(regex, '') // remove all HTML tags
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&lsquo;', '‘')
        .replaceAll('&rsquo;', '’')
        .replaceAll('&ldquo;', '“')
        .replaceAll('&rdquo;', '”')
        .trim();
  }

  getSavedNews(newsType) async {
    try {
      final bookmarks = await ref.watch(newsBookmarkProvider);
      final response = await ApiServices.post(endpoint: 'saved-news', queryParameters: {"ids": bookmarks, "news_type": newsType});
      if (response.containsKey("noInternet") && response["noInternet"] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NoInternetWidget(
              onRetry: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainScreen(
                            initialIndex: 3,
                          )),
                );
              },
            ),
          ),
        );
        return;
      }
      if (response['success']) {
        print("respons--$response");
        setState(() {
          savedNewsList = response['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error in getSaved News:::$e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(newsProvider);
    return Scaffold(
      body: Container(
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
              const Text(
                "SAVED",
                style: AppTextStyles.heading2,
              ),
              SizedBox(height: 20.h),

              // Toggle Button
              SavedNewsToggleBtn(
                isTextNewsIsSelected: isTextNewsIsSelected,
                onNewsBtnPress: () {
                  setState(() {
                    isTextNewsIsSelected = true;
                    isLoading = true;
                  });
                  getSavedNews("Text News");
                },
                onVideoBtnPress: () {
                  setState(() {
                    isTextNewsIsSelected = false;
                    isLoading = true;
                  });
                  getSavedNews("Video News");
                },
              ),

              SizedBox(height: 20.h),

              // Content Area (News or Videos)
              Expanded(
                child: isTextNewsIsSelected ? _buildNewsList(savedNewsList, isLoading) : _buildVideoList(savedNewsList, isLoading),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build News List
  Widget _buildNewsList(List<dynamic> savedNewsList, bool isLoading) {
    if (isLoading) {
      return const ShimmerLoading();
    } else if (savedNewsList.isEmpty) {
      return NoDataFoundScreen();
    } else {
      return ListView.builder(
        padding: EdgeInsets.all(0.sp),
        itemCount: savedNewsList.length,
        itemBuilder: (context, index) {
          final item = savedNewsList[index];
          return NewsCard(
              imageUrl: item['post_image'],
              title: item['title'],
              description: removeHtmlTags(item['description'] ?? ''),
              id: item['id'],
              category: item['category'],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailScreen(
                      categorizedNews: item['category'].toString(),
                      newsItemId: item['id'],
                    ),
                  ),
                );
              });
        },
      );
    }
  }

  /// Build Video List
  Widget _buildVideoList(List<dynamic> savedNewsList, bool isLoading) {
    if (isLoading) {
      return const ShimmerLoading();
    } else if (savedNewsList.isEmpty) {
      return NoDataFoundScreen();
    } else {
      return Expanded(
          child: ListView.builder(
        padding: EdgeInsets.all(0.sp),
        itemCount: savedNewsList.length,
        itemBuilder: (context, index) {
          final item = savedNewsList[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: VideoNewsCard(
              id: item['id'],
              videoUrl: item['video_link'],
              videoNewsTitle: item['title'],
              dateString: item['created_on'],
              onPressShareBtn: () {},
            ),
          );
        },
      ));
    }
  }
}
