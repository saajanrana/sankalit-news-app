import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/news_card.dart';
import '../widgets/category_scroller.dart';
import '../widgets/shimmer_loading.dart';
import '../../viewmodels/news_viewmodel.dart';
import '../../viewmodels/category_viewmodel.dart';
import '../../core/constants.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late ScrollController _scrollController;

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
    final categoryState = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () => ref.read(newsProvider.notifier).refresh(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Category Scroller
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: CategoryScroller(
                  categories: categoryState.categories,
                  selectedCategory: categoryState.selectedCategory,
                  onCategorySelected: (category) {
                    ref
                        .read(categoryProvider.notifier)
                        .selectCategory(category);
                    ref.read(newsProvider.notifier).loadNews(
                          category: category,
                          refresh: true,
                        );
                  },
                ),
              ),
            ),

            // News List
            if (newsState.isLoading && newsState.news.isEmpty)
              const SliverToBoxAdapter(
                child: ShimmerLoading(),
              )
            else if (newsState.error != null && newsState.news.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        Text(
                          AppStrings.error,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          newsState.error!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
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
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: NewsCard(news: newsState.news[index]),
                      );
                    } else if (newsState.isLoading) {
                      return Padding(
                        padding: EdgeInsets.all(16.w),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
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
    );
  }
}
