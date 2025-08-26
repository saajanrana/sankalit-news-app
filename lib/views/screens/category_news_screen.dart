import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/news_card.dart';
import '../widgets/shimmer_loading.dart';
import '../../models/category_model.dart';
import '../../viewmodels/news_viewmodel.dart';
import '../../core/constants.dart';

class CategoryNewsScreen extends ConsumerStatefulWidget {
  final CategoryModel category;

  const CategoryNewsScreen({super.key, required this.category});

  @override
  ConsumerState<CategoryNewsScreen> createState() => _CategoryNewsScreenState();
}

class _CategoryNewsScreenState extends ConsumerState<CategoryNewsScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      ref.read(categoryNewsProvider(widget.category.id).notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(categoryNewsProvider(widget.category.id));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              widget.category.iconPath,
              style: TextStyle(fontSize: 24.sp),
            ),
            SizedBox(width: 8.w),
            Text(
              widget.category.displayName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(categoryNewsProvider(widget.category.id).notifier).refresh(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
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
                          onPressed: () => ref.read(categoryNewsProvider(widget.category.id).notifier).refresh(),
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
                  childCount: newsState.news.length + (newsState.isLoading ? 1 : 0),
                ),
              ),
          ],
        ),
      ),
    );
  }
}