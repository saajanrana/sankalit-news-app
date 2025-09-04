import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:Sankalit/services/api_services.dart';
import 'package:Sankalit/viewmodels/category_viewmodel.dart';
import 'package:Sankalit/views/screens/news_by_category.dart';
import 'package:Sankalit/views/screens/news_detail_screen.dart';
import 'package:Sankalit/views/widgets/common_header.dart';
import 'package:Sankalit/views/widgets/home_screen_widgets/home_add_section.dart';
import 'package:Sankalit/views/widgets/home_screen_widgets/home_category_scroller.dart';
import 'package:Sankalit/views/widgets/home_screen_widgets/top_home_carousel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/news_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late ScrollController _scrollController;
  bool showReadmoreButton = false;
  int _currentIndex = 0;
  List<Map<String, String>> homeCategories = [];
  List<Map<String, dynamic>> breakingNews = [];
  List<Map<String, dynamic>> trendingNews = [];
  Map<String, List<Map<String, dynamic>>> categorizedNews = {};
  List<Map<String, dynamic>> categorizedNewsList = [];

  String selectedCatId = '';
  bool isLoading = true;

  List<dynamic> adsList = [];

  final categoryName = "उत्तराखण्ड";

  String removeHtmlTags(String htmlText) {
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(regex, '').trim();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _initializeData();
  }

  void _initializeData() async {
    setState(() => isLoading = true);

    await Future.wait([fetchCategories(), fetchBreakingAndTrendingNews(), fetchHomeScreenData(), fetchAdsData()]);

    setState(() => isLoading = false);
  }

  Future<void> fetchCategories() async {
    try {
      final response = await ApiServices.get(endpoint: "category");
      print("Categories Response: $response");

      if (response != null && response['success'] == true) {
        final data = response['data'];

        if (data != null && data is Map<String, dynamic> && data.isNotEmpty) {
          homeCategories.clear();
          homeCategories.add({'id': '01', 'name': 'होम'});

          final Map<String, List<Map<String, dynamic>>> formattedData = {};

          data.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              final List<Map<String, dynamic>> subCategories = value.map((item) => Map<String, dynamic>.from(item)).toList();

              formattedData[key] = subCategories;

              // ✅ Add each subcategory (id + name)
              for (var item in subCategories) {
                if (item.containsKey('id') && item.containsKey('name')) {
                  homeCategories.add({'id': item['id'].toString(), 'name': item['name'].toString()});
                }
              }
            }
          });

          // ✅ Update provider
          ref.read(categoryProvider.notifier).setCategories(formattedData);
        }
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
      homeCategories = [];
    }
  }

  Future<void> fetchBreakingAndTrendingNews() async {
    try {
      final response = await ApiServices.get(endpoint: "breaking-trending-news");
      if (response != null && response['success'] == true) {
        final data = response['data'];
        if (data != null && data is Map<String, dynamic> && data.isNotEmpty) {
          final List<dynamic> breakingNewsList = data['breaking_news'] ?? [];
          final List<Map<String, dynamic>> breaking = breakingNewsList.map((item) => Map<String, dynamic>.from(item)).toList();
          final List<dynamic> trendingNewsList = data['trending_news'] ?? [];
          final List<Map<String, dynamic>> trending = trendingNewsList.map((item) => Map<String, dynamic>.from(item)).toList();

          breakingNews = breaking;
          trendingNews = trending;
        }
      }
    } catch (e) {
      debugPrint("Error fetching breaking and trending news: $e");
      breakingNews = [];
      trendingNews = [];
    }
  }

  Future<void> fetchHomeScreenData() async {
    setState(() {
      isLoading = true;
      showReadmoreButton = false;
      categorizedNews.clear();
      categorizedNewsList.clear(); // ✅ Clear old data before adding new
      categorizedNews = {};
      categorizedNewsList = [];
    });

    try {
      final response = await ApiServices.get(endpoint: "home");
      if (response != null && response['success'] == true) {
        final data = response['data'];

        if (data != null && data is Map<String, dynamic> && data.isNotEmpty) {
          Map<String, List<Map<String, dynamic>>> tempMap = {};
          List<Map<String, dynamic>> categoryObjectList = [];

          data.forEach((category, newsList) {
            if (newsList is List) {
              List<Map<String, dynamic>> categoryNewsList = []; // ✅ Local list

              for (var news in newsList) {
                final newsItem = {
                  'category': category,
                  'id': news['id'],
                  'title': news['title'],
                  'description': news['description'],
                  'post_image': news['post_image'],
                  'created_on': news['created_on'],
                };

                categoryNewsList.add(newsItem);
              }

              tempMap[category] = categoryNewsList;

              categoryObjectList.add({
                "category": category,
                "news": categoryNewsList,
              });
            }
          });

          setState(() {
            categorizedNews = tempMap;
            categorizedNewsList = categoryObjectList;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching home screen data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchNewsByCategory(String newsCategory, int newsItemId) async {
    try {
      setState(() {
        isLoading = true;
        categorizedNews.clear();
        categorizedNewsList.clear();
        categorizedNews = {};
      });

      final response = await ApiServices.get(
        endpoint: "news-by-category?cid=$newsItemId",
      );

      if (response != null && response['success'] == true) {
        List<dynamic> newNews = response['data']['news'] ?? [];

        if (newNews.isNotEmpty) {
          Map<String, List<Map<String, dynamic>>> tempMap = {};
          List<Map<String, dynamic>> categoryObjectList = [];

          List<Map<String, dynamic>> categoryNewsList = []; // ✅ Local list

          for (var news in newNews) {
            if (news is Map<String, dynamic>) {
              final newsItem = {
                'category': newsCategory,
                'id': news['id'],
                'title': news['title'],
                'description': news['description'],
                'post_image': news['post_image'],
                'created_on': news['created_on'] ?? '',
              };

              categoryNewsList.add(newsItem);
            }
          }

          tempMap[newsCategory] = categoryNewsList;

          categoryObjectList.add({
            "category": newsCategory,
            "news": categoryNewsList,
          });

          setState(() {
            categorizedNews = tempMap;
            categorizedNewsList = categoryObjectList;
            showReadmoreButton = true;
            isLoading = false;
          });

          print('Categorized News: $categorizedNews');
        }
      }
    } catch (e) {
      print("Error fetching news by category: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Load more data if needed
    }
  }

  Future<void> fetchAdsData() async {
    try {
      final response = await ApiServices.get(endpoint: "ads-content");
      if (response['success']) {
        setState(() {
          adsList = response['data'];
        });
      }
      print("responseFetchAdsData:::::>>>$response");
    } catch (e) {
      print("Error in fetchAdsDataFnc::::$e");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: const CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 40.h, bottom: 20.h),
            child: const CommonHeader(),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
               color: AppTheme.primaryColor,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Breaking News Ticker
                  SliverToBoxAdapter(
                    child: BreakingNewsTicker(
                      breakingText: 'Breaking',
                      newsText: breakingNews.isNotEmpty ? breakingNews.map((item) => item['title']).join(' | ') : 'Loading breaking news...',
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),

                  // Ads Image section
                  adsList.isEmpty ? SliverToBoxAdapter(child: SizedBox()) : AddsDynamicImageList(imageUrls: adsList),
                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),

                  // Trending News Section
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            'TRENDING NEWS',
                            style: AppTextStyles.heading1.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.lightTextPrimary,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        _buildTrendingNewsCarousel(),
                        SizedBox(height: 10.h),
                        _buildCarouselIndicator(),
                      ],
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),

                  // Category Tabs
                  SliverToBoxAdapter(
                    child: HorizontalCategoryTabs(
                      categories: homeCategories.map((cat) => cat['name']!).toList(),
                      onTabSelected: (index) {
                        final selectedCategory = homeCategories[index];
                        final categoryId = selectedCategory['id'];
                        final categoryName = selectedCategory['name'];
                        selectedCatId = selectedCategory['id']!;

                        if (categoryId == '01') {
                          print("Home selected");
                          fetchHomeScreenData();
                        } else {
                          _fetchNewsByCategory(categoryName!, int.parse(categoryId!));
                        }
                      },
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),

                  // Ads Image section
                  adsList.isEmpty ? const SliverToBoxAdapter(child: SizedBox()) : AddsDynamicImageList(imageUrls: adsList),

                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),

                  ..._buildAllCategoriesNews(),

                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingNewsCarousel() {
    if (trendingNews.isEmpty) {
      return SizedBox(
        height: 200.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) => Container(
            width: 300.w,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            child: _buildCarouselItem(imageUrl: '', title: '', newsItemId:'', categorizedNews: ''),
          ),
        ),
      );
    }

    return CarouselSlider(
      items: trendingNews.map((item) {
        return _buildCarouselItem(
          imageUrl: item['post_image'] ?? '',
          title: item['title'] ?? '',
          newsItemId: item['id'] ?? 0,
          categorizedNews: item['category_name'] ?? '' ,
        );
      }).toList(),
      options: CarouselOptions(
        height: 200.h,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildCarouselIndicator() {
    return Center(
      child: AnimatedSmoothIndicator(
        activeIndex: _currentIndex,
        count: trendingNews.isEmpty ? 3 : trendingNews.length,
        effect: const ExpandingDotsEffect(
          activeDotColor: Colors.red,
          dotColor: Colors.black26,
          dotHeight: 8,
          dotWidth: 8,
        ),
      ),
    );
  }

  List<Widget> _buildAllCategoriesNews() {
    List<Widget> slivers = [];
    if (isLoading) {
      // ✅ Show shimmer placeholders
      slivers.add(
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Image placeholder
                      Container(
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // ✅ Title placeholder
                      Container(
                        height: 20.h,
                        width: 200.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      SizedBox(height: 6.h),

                      // ✅ Description placeholder line 1
                      Container(
                        height: 14.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),

                      SizedBox(height: 6.h),

                      // ✅ Description placeholder line 2
                      Container(
                        height: 14.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: 6, // show 6 shimmer items
          ),
        ),
      );
      return slivers;
    }

    // ✅ If not loading, show actual data
    for (var categoryData in categorizedNewsList) {
      // print("categoryData<<<<<<<<<<<<<<<<<<<<<<<<<<<: $categoryData");
      final categoryId = categoryData['id'];
      final categoryName = categoryData['category'] as String;
      final newsList = categoryData['news'] as List<Map<String, dynamic>>;

      // Category Header
      slivers.add(
        SliverToBoxAdapter(
          child: Container(
            height: 40.h,
            width: double.infinity,
            color: Colors.black,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              categoryName,
              style: AppTextStyles.heading2Hindi.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.darkTextPrimary,
              ),
            ),
          ),
        ),
      );

      // News List for Category
      slivers.add(
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = newsList[index];
              // print("newsData:::::$item");
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: NewsCard(
                      title: item['title'] ?? '',
                      id: item['id'] ?? "",
                      description: removeHtmlTags(item['description'] ?? ''),
                      imageUrl: item['post_image'] ?? '',
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
                      },
                    ),
                  ),
                  if (index != newsList.length - 1)
                    Divider(
                      thickness: 1,
                      color: Colors.grey.withOpacity(0.3),
                      indent: 16.w,
                      endIndent: 16.w,
                    ),
                ],
              );
            },
            childCount: newsList.length,
          ),
        ),
      );

      slivers.add(SliverToBoxAdapter(child: SizedBox(height: 10.h)));

      if (showReadmoreButton) {
        // final categoryId = categoryData['categoryId'] as int;
        final categoryName = categoryData['category'] as String;
        slivers.add(SliverToBoxAdapter(
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsCategoryScreen(
                      categorizedNews: categoryName,
                      newsItemId: int.parse(selectedCatId),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                "READ MORE",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ));
      }
// ✅ Dynamic image list
      slivers.add(SliverToBoxAdapter(child: SizedBox(height: 20.h)));
      slivers.add(
        adsList.isEmpty ? SliverToBoxAdapter(child: SizedBox()) : AddsDynamicImageList(imageUrls: adsList),
      );
      slivers.add(SliverToBoxAdapter(child: SizedBox(height: 20.h)));
    }

    return slivers;
  }

  Widget _buildCarouselItem({required String? imageUrl, required String? title, required newsItemId, required categorizedNews}) {
    bool showShimmer = (imageUrl == null || imageUrl.isEmpty) || (title == null || title.isEmpty);
    if (showShimmer) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: 200,
            color: Colors.white,
          ),
        ),
      );
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(
              newsItemId: newsItemId,
              categorizedNews: categorizedNews,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              height: 200,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyHindi.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkTextPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
