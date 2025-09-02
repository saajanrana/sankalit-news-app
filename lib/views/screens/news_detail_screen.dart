import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:Sankalit/services/api_services.dart';
import 'package:Sankalit/views/widgets/common_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
  

  bool isLoading = true;
 String removeHtmlTags(String htmlString) {
  // Parse the HTML and extract text
  final document = html_parser.parse(htmlString);
  return document.body?.text.trim() ?? '';
}
  @override
  void initState() {
    super.initState();
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
      final response = await ApiServices.get(
          endpoint: "news-details?news_id=${widget.newsItemId}");

      if (response != null && response['success'] == true) {
        if (response != null && response['success'] == true) {
          final data = response['data'];
          if (data != null && data is Map<String, dynamic>) {
            setState(() {
              newsDetails = data;
              isLoading = false;
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
    return Scaffold(
      backgroundColor: Colors.white,
      body:isLoading
    ? Padding(
        padding: EdgeInsets.all(16.w),
        child: shimmerLoadingEffect(context),
      )
    : Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 16.w, right: 16.w, top: 40.h, bottom: 20.h),
            child: const CommonHeader(),
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
                              background: newsDetails!['post_image'] != null &&
                                      newsDetails!['post_image'].isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: newsDetails!['post_image'],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 50.sp,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant,
                                      child: Icon(
                                        Icons.article,
                                        size: 50.sp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                            ),
                          ),

                          // ✅ Article Details
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.categorizedNews,
                                        style: AppTextStyles.heading3Hindi
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.lightTextPrimary,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        DateFormat('dd-MMM-yyyy').format(
                                          DateTime.parse(
                                              newsDetails!['created_on']),
                                        ),
                                        style:
                                            AppTextStyles.smallHindi.copyWith(
                                          color: AppTheme.lightTextPrimary,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.darkBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h, horizontal: 10.w),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "SHARE",
                                            style: AppTextStyles.bodyBoldHindi
                                                .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  AppTheme.lightBackgroundColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Image.asset(
                                          // isBookmarked ?
                                          'assets/icons/bookmarkActive.png',
                                          //  : 'assets/icons/bookmark.png',
                                          width: 24.w,
                                          height: 24.h,
                                        ),
                                        onPressed: () {},
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
                                    removeHtmlTags(
                                        newsDetails!['description'] ?? ''),
                                    style: AppTextStyles.bodyHindi,
                                  ),
                                  SizedBox(height: 20.h),
                                   
                                  Container(
                                    height: 40.h,
                                    width: double.infinity,
                                    color: Colors.black,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w),
                                    child: Text(
                                      'READ MORE',
                                      style: AppTextStyles.heading2.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.darkTextPrimary,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
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


