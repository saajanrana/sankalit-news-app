import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/views/widgets/common_header.dart';
import 'package:news_app/views/widgets/home_screen_widgets/home_add_section.dart';
import 'package:news_app/views/widgets/home_screen_widgets/home_category_scroller.dart';
import 'package:news_app/views/widgets/home_screen_widgets/top_home_carousel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/constants.dart';
import '../../viewmodels/news_viewmodel.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/news_card.dart';
import '../widgets/shimmer_loading.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late ScrollController _scrollController;
  int _currentIndex = 0;
  final List<String> homeCategories = [
    'होम',
    'उत्तराखण्ड',
    'उत्तर प्रदेश',
    'देश',
    'पर्यटन',
  ];
  final List<String> imageUrls = [
    'https://sankalit.com/images/augtop1.jpeg',
    'https://sankalit.com/images/augtop2.jpeg',
  ];
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load initial news
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(newsProvider.notifier).loadNews(refresh: true);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(newsProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider);
  

    return Scaffold(
    
      endDrawer: const CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 40.h, bottom: 20.h),
            child: const CommonHeader(),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(newsProvider.notifier).refresh(),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
              
                  const SliverToBoxAdapter(
                    child: BreakingNewsTicker(
                      breakingText: 'Breaking',
                      newsText:
                          'मुख्यमंत्री श्री पुष्कर सिंह धामी ने प्रधानमंत्री श्री नरेंद्र मोदी एवं | मुख्यमंत्री और अधिकारियों ने गैरसैंण में ‘एक पेड़ माँ के नाम’ अभियान के तहत किया पौधा रोपण.',
                    ),
                  ),
            
                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            
                  // ✅ add Image section
                  AddsDynamicImageList(
                    imageUrls: imageUrls,
                  ),
            
                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            
                  // ✅ Trending News header + Carousel
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            'TRENDING NEWS',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        CarouselSlider(
                          items: [
                            _buildCarouselItem(
                              imageUrl:
                                  'https://sankalit.com/post_images/featured_1756050433.jpg',
                              title: 'भूस्खलन से बद्रीनाथ राजमार्ग बंद, यात्री ...',
                            ),
                            _buildCarouselItem(
                              imageUrl:
                                  'https://sankalit.com/post_images/featured_1755962919.jpg',
                              title: 'ताज़ा खबरें - जानिए क्या हुआ',
                            ),
                            _buildCarouselItem(
                              imageUrl:
                                  'https://sankalit.com/post_images/featured_1755962319.jpg',
                              title: 'खेल जगत से जुड़ी बड़ी खबरें',
                            ),
                          ],
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
                        ),
                        SizedBox(height: 10.h),
                        Center(
                          child: AnimatedSmoothIndicator(
                            activeIndex: _currentIndex,
                            count: 3,
                            effect: const ExpandingDotsEffect(
                              activeDotColor: Colors.red,
                              dotColor: Colors.black26,
                              dotHeight: 8,
                              dotWidth: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 20.h),
                  ),
                  
                  SliverToBoxAdapter(
                    child: HorizontalCategoryTabs(
                      categories: homeCategories,
                      onTabSelected: (index) {},
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 20.h),
                  ),
            
                  SliverToBoxAdapter(
                    child: Container(
                      height: 40.h,
                      width: double.infinity,
                      color: Colors.black,
                      alignment: Alignment
                          .centerLeft, // ✅ Centers vertically but left aligned
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        'उत्तराखण्ड',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
            
                  // ✅ News list section
                  if (newsState.isLoading && newsState.news.isEmpty)
                    const SliverToBoxAdapter(child: ShimmerLoading())
                  else if (newsState.error != null && newsState.news.isEmpty)
                    SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                         padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 8.h),
                          child: Column(
                            children: [
                              Text(
                                AppStrings.error,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              SizedBox(height: 8),
                              Text(
                                newsState.error!,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    ref.read(newsProvider.notifier).refresh(),
                                child: const Text(AppStrings.retry),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < newsState.news.length) {
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 8.h),
                                  child: NewsCard(news: newsState.news[index]),
                                ),
                                // ✅ Horizontal line after each item except the last one
                                if (index != newsState.news.length - 1)
                                  Divider(
                                    thickness: 1,
                                    color: Colors.grey.withOpacity(0.3),
                                    indent: 16.w,
                                    endIndent: 16.w,
                                  ),
                              ],
                            );
                          } else if (newsState.isLoading) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return null;
                        },
                        childCount:
                            newsState.news.length + (newsState.isLoading ? 1 : 0),
                      ),
                    ),
                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                  // ✅ add Image section
                  AddsDynamicImageList(
                    imageUrls: imageUrls,
                  ),
            
                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 40.h,
                      width: double.infinity,
                      color: Colors.black,
                      alignment: Alignment
                          .centerLeft, // ✅ Centers vertically but left aligned
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        'नैनीताल',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 10.h)),
                  // ✅ News list section
                  if (newsState.isLoading && newsState.news.isEmpty)
                    const SliverToBoxAdapter(child: ShimmerLoading())
                  else if (newsState.error != null && newsState.news.isEmpty)
                    SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                AppStrings.error,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              SizedBox(height: 8),
                              Text(
                                newsState.error!,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    ref.read(newsProvider.notifier).refresh(),
                                child: const Text(AppStrings.retry),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
            
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < newsState.news.length) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: VerticalNewsCard(news: newsState.news[index]),
                            );
                          } else if (newsState.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return null;
                        },
                        childCount:
                            newsState.news.length + (newsState.isLoading ? 1 : 0),
                      ),
                      
                    ),
            
                  // ✅ add Image section
                  AddsDynamicImageList(
                    imageUrls: imageUrls,
                  ),
            
                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 40.h,
                      width: double.infinity,
                      color: Colors.black,
                      alignment: Alignment
                          .centerLeft, // ✅ Centers vertically but left aligned
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        'चमोली',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 10.h)),
                  if (newsState.isLoading && newsState.news.isEmpty)
                    const SliverToBoxAdapter(child: ShimmerLoading())
                  else if (newsState.error != null && newsState.news.isEmpty)
                    SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                AppStrings.error,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              SizedBox(height: 8),
                              Text(
                                newsState.error!,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    ref.read(newsProvider.notifier).refresh(),
                                child: const Text(AppStrings.retry),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < newsState.news.length) {
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 8.h),
                                  child: NewsCard(news: newsState.news[index]),
                                ),
                                // ✅ Horizontal line after each item except the last one
                                if (index != newsState.news.length - 1)
                                  Divider(
                                    thickness: 1,
                                    color: Colors.grey.withOpacity(0.3),
                                    indent: 16.w,
                                    endIndent: 16.w,
                                  ),
                              ],
                            );
                          } else if (newsState.isLoading) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return null;
                        },
                        childCount:
                            newsState.news.length + (newsState.isLoading ? 1 : 0),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem({required String imageUrl, required String title}) {
    return Stack(
      children: [
        // Main image container
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            width: double.infinity,
            height: 200.h,
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
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
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

        // Black slip/band at bottom for text
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16.r),
              bottomRight: Radius.circular(16.r),
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),

        // Optional: Add a subtle border
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
