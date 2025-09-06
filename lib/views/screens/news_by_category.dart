import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:Sankalit/services/api_services.dart';
import 'package:Sankalit/views/screens/main_screen.dart';
import 'package:Sankalit/views/screens/news_detail_screen.dart';
import 'package:Sankalit/views/widgets/common_header.dart';
import 'package:Sankalit/views/widgets/news_card.dart';
import 'package:Sankalit/views/widgets/no_data_found_screen.dart';
import 'package:Sankalit/views/widgets/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class NewsCategoryScreen extends ConsumerStatefulWidget {
  final int newsItemId;
  final String categorizedNews;

  const NewsCategoryScreen({
    super.key,
    required this.newsItemId,
    required this.categorizedNews,
  });

  @override
  ConsumerState<NewsCategoryScreen> createState() => _NewsCategoryScreenState();
}

class _NewsCategoryScreenState extends ConsumerState<NewsCategoryScreen> {
  bool isLoading = true; // For first page loading
  bool isLoadingMore = false; // For pagination loader
  bool hasMore = true; // To stop calling API when no more data
  int page = 1;
  final int perPage = 20;

  List<dynamic> newsList = [];
  final ScrollController _scrollController = ScrollController();

  String removeHtmlTags(String htmlText) {
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(regex, '').trim();
  }

  @override
  void initState() {
    super.initState();
    _fetchNewsByCategory();

    // ✅ Add scroll listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore &&
          hasMore) {
        _loadMoreNews();
      }
    });
  }

  Future<void> _fetchNewsByCategory() async {
    try {
      final response = await ApiServices.get(
        endpoint:
            "news-by-category?cid=${widget.newsItemId}&page=$page&per_page=$perPage",
      );
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
                      builder: (context) => const MainScreen(
                            initialIndex: 1,
                          )),
                );
              },
            ),
          ),
        );
        return;
      }
      print("response: $response");

      if (response != null && response['success'] == true) {
        List<dynamic> newNews = response['data']['news'] ?? [];

        setState(() {
          newsList.addAll(newNews);
          isLoading = false;
          hasMore =
              newNews.length == perPage; // If less than perPage → no more data
        });
      }
    } catch (e) {
      print("Error fetching news by category: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadMoreNews() async {
    setState(() => isLoadingMore = true);
    page++; // ✅ Increment page
    await _fetchNewsByCategory();
    setState(() => isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Padding(
              padding: EdgeInsets.all(16.w),
              child: shimmerLoadingEffect(context),
            )
          : Column(
              children: [
                // ✅ Header
                Padding(
                  padding: EdgeInsets.only(
                      left: 16.w, right: 16.w, top: 40.h, bottom: 20.h),
                  child: const CommonHeader(
                    showBackBtn: true,
                  ),
                ),
                const SizedBox(height: 20),

                // ✅ Category Title
                Container(
                  height: 40.h,
                  width: double.infinity,
                  color: Colors.black,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    widget.categorizedNews,
                    style: AppTextStyles.heading2Hindi.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkTextPrimary,
                    ),
                  ),
                ),

                // ✅ News List with Pagination
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: newsList.isEmpty
                        ? const NoDataFoundScreen()
                        : ListView.separated(
                            controller: _scrollController,
                            itemCount:
                                newsList.length + (isLoadingMore ? 1 : 0),
                            separatorBuilder: (context, index) => Divider(
                              thickness: 1,
                              color: Colors.grey.withOpacity(0.3),
                              indent: 16.w,
                              endIndent: 16.w,
                            ),
                            itemBuilder: (context, index) {
                              if (index == newsList.length) {
                                // ✅ Loader at the bottom
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                );
                              }

                              final item = newsList[index];

                              return NewsCard(
                                title: item['title'] ?? '',
                                id: item['id'] ?? 0,
                                description:
                                    removeHtmlTags(item['description'] ?? ''),
                                imageUrl: item['post_image'] ?? '',
                                category: item['category'] ?? '',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDetailScreen(
                                        categorizedNews: widget.categorizedNews,
                                        newsItemId: item['id'],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
    );
  }

  /// ✅ Shimmer Effect for List Items
  Widget shimmerLoadingEffect(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Fake image with rounded corners
                Container(
                  height: 80.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r), // Rounded corners
                  ),
                ),
                SizedBox(width: 12.w),
                // ✅ Fake text with rounded corners
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 14.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 14.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
