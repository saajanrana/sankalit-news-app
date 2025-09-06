import 'package:Sankalit/controller/book_mark_notifier.dart';
import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:Sankalit/services/api_services.dart';
import 'package:Sankalit/views/screens/main_screen.dart';
import 'package:Sankalit/views/widgets/common_header.dart';
import 'package:Sankalit/views/widgets/common_share_url_model.dart';
import 'package:Sankalit/views/widgets/news_card.dart';
import 'package:Sankalit/views/widgets/no_internet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class NewsDetailScreen extends ConsumerStatefulWidget {
  final int newsItemId;
  final String categorizedNews;

  const NewsDetailScreen({
    super.key,
    required this.newsItemId,
    required this.categorizedNews,
  });

  @override
  ConsumerState<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends ConsumerState<NewsDetailScreen> {
  Map<String, dynamic>? newsDetails;
  var suggestedNews;
  var Url;

  bool isLoading = true;
  String removeHtmlTags(String htmlString) {
    // Parse the HTML and extract text
    final document = html_parser.parse(htmlString);
    return document.body?.text.trim() ?? '';
  }

  @override
  void initState() {
    super.initState();
    Url = dotenv.env['URL'];
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      fetchNewsDetails(),
    ]);
  }

  Future<void> fetchNewsDetails() async {
    print("Fetching details for news ID: ${widget.newsItemId}");
    try {
      final response = await ApiServices.get(endpoint: "news-details?news_id=${widget.newsItemId}");
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
                          const MainScreen(initialIndex: 0,)), 
                );
              },
            ),
          ),
        );
        return;
      }
      if (response != null && response['success'] == true) {
        if (response != null && response['success'] == true) {
          final data = response['data']['news_detail'];

          if (data != null && data is Map<String, dynamic>) {
            setState(() {
              newsDetails = data;
              isLoading = false;
              suggestedNews = response['data']['recommended_news'];
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching news details: $e");
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("suggestedData::::$newsDetails");
    final bookmarks = ref.watch(newsBookmarkProvider);

    final isBookmarked = bookmarks.contains(widget.newsItemId);
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Padding(
              padding: EdgeInsets.all(16.w),
              child: shimmerLoadingEffect(context),
            )
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 50.h, bottom: 10.h),
                  child: const CommonHeader(
                    showBackBtn: true,
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      // ✅ SliverAppBar with Image
                      SliverAppBar(
                        expandedHeight: 250.h,
                        floating: false,
                        pinned: false,
                        automaticallyImplyLeading: false,
                        flexibleSpace: FlexibleSpaceBar(
                          background: newsDetails!['post_image'] != null && newsDetails!['post_image'].isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: newsDetails!['post_image'],
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => Container(
                                    color: Theme.of(context).colorScheme.surfaceVariant,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Theme.of(context).colorScheme.surfaceVariant,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 50.sp,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                )
                              : Container(
                                  color: Theme.of(context).colorScheme.surfaceVariant,
                                  child: Icon(
                                    Icons.article,
                                    size: 50.sp,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                        ),
                      ),

                     
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                newsDetails!['title'] ?? '',
                                style: AppTextStyles.heading1Hindi.copyWith(
                                  color: AppTheme.lightTextPrimary,
                                ),
                              ),
                              SizedBox(height: 12.h),

                              // ✅ Row with Category and Date
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  newsDetails!['category_name'] != "null"
                                      ? Text(
                                           newsDetails!['category_name'] ?? '',
                                          style: AppTextStyles.heading3Hindi.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.lightTextPrimary,
                                          ),
                                        )
                                      : SizedBox(),
                                  // widget.categorizedNews != "null" ? SizedBox(width: 8.w) : SizedBox(),
                                  Text(
                                    DateFormat('dd-MMM-yyyy').format(
                                      DateTime.parse(newsDetails!['created_on']),
                                    ),
                                    style: AppTextStyles.smallHindi.copyWith(
                                      color: AppTheme.lightTextPrimary,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      String slug = newsDetails!['slug_title'] ?? '';
                                      String formattedSlug = slug.replaceAll(" ", "_");
                                      showShareModal(context, '$Url/${newsDetails!['id'] ?? 0}/$formattedSlug');
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.darkBackgroundColor,
                                        borderRadius: BorderRadius.circular(5.r),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "SHARE",
                                        style: AppTextStyles.bodyBoldHindi.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.lightBackgroundColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Image.asset(
                                      isBookmarked ? 'assets/icons/bookmarkActive.png' : 'assets/icons/bookmark.png',
                                      width: 24.w,
                                      height: 24.h,
                                    ),
                                    onPressed: () {
                                      ref.read(newsBookmarkProvider.notifier).toggleBookmark(widget.newsItemId);
                                    },
                                  ),
                                ],
                              ),

                              // ✅ Spacer
                              SizedBox(height: 10.h),
                              Divider(
                                thickness: 1,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              SizedBox(height: 8.h),

                              // ✅ Description without HTML
                              Text(
                                removeHtmlTags(newsDetails!['description'] ?? ''),
                                style: AppTextStyles.bodyHindi,
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          height: 40.h,
                          width: double.infinity,
                          color: Colors.black,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            'RELATED NEWS',
                            style: AppTextStyles.heading2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkTextPrimary,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 10.h),
                      ),
                      // 📰 Suggested News List
                      
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = suggestedNews[index];
                            print("news details id >>>>>>>>>>>>>>${item['category']}");
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                              child: NewsCard(
                                title: item['title'] ?? '',
                                id: item['id'] ?? 0,
                                description: item['description'] ?? '',
                                imageUrl: item['post_image'] ?? '',
                                category: item['category'] ?? '',
                                publishedAt: item['created_on'] ?? '',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDetailScreen(
                                        newsItemId: int.parse(item['id'].toString()),
                                        categorizedNews: item['category'].toString(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          childCount: suggestedNews?.length ?? 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget shimmerLoadingEffect(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w), // Added padding for better layout
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Fake Image Container (Hero image)
            Container(
              height: 350.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 20.h),

            // ✅ Fake Title
            Container(
              height: 24.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 12.h),

            // ✅ Fake Subtitle Row
            Row(
              children: [
                _buildShimmerBox(width: 100.w, height: 18.h),
                SizedBox(width: 16.w),
                _buildShimmerBox(width: 80.w, height: 18.h),
                SizedBox(width: 16.w),
                _buildShimmerBox(width: 80.w, height: 18.h),
              ],
            ),
            SizedBox(height: 20.h),

            // ✅ Fake Description (3 lines)
            _buildShimmerBox(width: double.infinity, height: 18.h),
            SizedBox(height: 10.h),
            _buildShimmerBox(width: double.infinity, height: 18.h),
            SizedBox(height: 10.h),
            _buildShimmerBox(width: 200.w, height: 18.h),
            SizedBox(height: 24.h),

            // ✅ Fake Button
            Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 24.h),

            // ✅ Two Fake Cards (side by side)
            Row(
              children: [
                Expanded(child: _buildShimmerBox(width: double.infinity, height: 100.h)),
                SizedBox(width: 16.w),
                Expanded(child: _buildShimmerBox(width: double.infinity, height: 100.h)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Helper widget for rounded shimmer boxes
  Widget _buildShimmerBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}
