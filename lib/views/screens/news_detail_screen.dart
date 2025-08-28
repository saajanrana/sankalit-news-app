import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/constants.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:Sankalit/viewmodels/news_viewmodel.dart';
import 'package:Sankalit/views/widgets/common_header.dart';
import 'package:Sankalit/views/widgets/news_card.dart';
import 'package:Sankalit/views/widgets/shimmer_loading.dart';

import '../../models/news_model.dart';
import '../../viewmodels/bookmark_viewmodel.dart';

class NewsDetailScreen extends ConsumerWidget {
  final NewsModel news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkNotifier = ref.read(bookmarkProvider.notifier);
    final isBookmarked = bookmarkNotifier.isBookmarked(news.url);
    final newsState = ref.watch(newsProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 40.h, bottom: 20.h),
            child: const CommonHeader(),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                // ✅ SliverAppBar
                SliverAppBar(
                  expandedHeight: 250.h,
                  floating: false,
                  pinned: false,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: news.urlToImage != null
                        ? CachedNetworkImage(
                            imageUrl: news.urlToImage!,
                            fit: BoxFit.cover,
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

                // ✅ Article Details
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news.title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, height: 1.3),
                        ),
                        SizedBox(height: 12.h),

                        // ✅ Row with Source, Date, Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (news.source?.name != null)
                              Text(
                                "उत्तराखण्ड",
                                style: AppTextStyles.heading3.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.lightTextPrimary,
                                ),
                              ),
                            SizedBox(width: 8.w),
                            Text(
                              DateFormat('dd-MMM-yyyy').format(news.publishedAt),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.darkBackgroundColor,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                                alignment: Alignment.center,
                                child: Text(
                                  "SHARE",
                                  style: AppTextStyles.small.copyWith(
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
                                bookmarkNotifier.toggleBookmark(news);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // ✅ Author
                        if (news.author != null) ...[
                          Row(
                            children: [
                              Icon(Icons.person, size: 16.sp, color: Colors.grey),
                              SizedBox(width: 4.w),
                              Text(
                                'By ${news.author}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                        ],

                        if (news.description != null) ...[
                          Text(
                            news.description!,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.5, color: Colors.black87),
                          ),
                          SizedBox(height: 20.h),
                        ],

                        if (news.content != null) ...[
                          Text(
                            news.content!,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ],
                    ),
                  ),
                ),

                // ✅ Black Container Section
                SliverToBoxAdapter(
                  child: Container(
                    height: 40.h,
                    width: double.infinity,
                    color: Colors.black,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      'READ MORE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // ✅ Spacer
                SliverToBoxAdapter(child: SizedBox(height: 10.h)),

                // ✅ Loading/Error or Grid
                if (newsState.isLoading && newsState.news.isEmpty)
                  const SliverToBoxAdapter(child: ShimmerLoading())
                else if (newsState.error != null && newsState.news.isEmpty)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(AppStrings.error, style: Theme.of(context).textTheme.headlineSmall),
                            SizedBox(height: 8),
                            Text(newsState.error!, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => ref.read(newsProvider.notifier).refresh(),
                              child: const Text(AppStrings.retry),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.70,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < newsState.news.length) {
                            return VerticalNewsCard(news: newsState.news[index]);
                          } else if (newsState.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return null;
                        },
                        childCount: newsState.news.length + (newsState.isLoading ? 1 : 0),
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
}
