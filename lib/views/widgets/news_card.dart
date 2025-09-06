import 'package:Sankalit/controller/book_mark_notifier.dart';
import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../models/news_model.dart';
import '../../viewmodels/bookmark_viewmodel.dart';

class NewsCard extends ConsumerWidget {
  final String title;
  final int id;
  final String? description;
  final String? imageUrl;
  final String? publishedAt;
  final bool showBookmarkButton;
  final String? created_on;
  final VoidCallback onTap;

  const NewsCard({
    super.key,
    required this.title,
    required this.id,
    this.description,
    this.created_on,
    this.imageUrl,
    this.publishedAt,
    this.showBookmarkButton = false,
    required category,
    required this.onTap,
  });

  String limitWords(String text, int wordLimit) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    String plainText = text.replaceAll(exp, '').replaceAll(RegExp(r'\s+'), ' ').trim();

    // Limit words
    final words = plainText.split(' ');
    if (words.length <= wordLimit) return plainText;
    return words.take(wordLimit).join(' ') + '...';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(newsBookmarkProvider);
    final isBookmarked = bookmarks.contains(id);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 170.h,
        child: Row(
          children: [
            // Left side image
            SizedBox(
              width: 140.w,
              height: 150.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) => Container(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 30.sp,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Icon(
                          Icons.article,
                          size: 30.sp,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),
            ),

            // Right side content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title and description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            limitWords(title, 18),
                            style: AppTextStyles.heading3Hindi.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.lightTextPrimary,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Description (if available)
                          if (description != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              limitWords(description!, 30),
                              style: AppTextStyles.smallHindi.copyWith(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Bottom row with source, date and bookmark
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side - Source and Date
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                created_on ?? '',
                                style: AppTextStyles.smallHindi.copyWith(
                                  color: AppTheme.lightTextPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right side - Bookmark button

                        Container(
                          width: 32.w,
                          height: 32.h,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Image.asset(
                              isBookmarked ? 'assets/icons/bookmarkActive.png' : 'assets/icons/bookmark.png',
                              width: 22.w,
                              height: 22.h,
                              fit: BoxFit.contain,
                            ),
                            onPressed: () async {
                              ref.read(newsBookmarkProvider.notifier).toggleBookmark(id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerticalNewsCard extends ConsumerWidget {
  final NewsModel news;
  final bool showBookmarkButton;

  const VerticalNewsCard({
    super.key,
    required this.news,
    this.showBookmarkButton = true,
  });
  String removeHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkNotifier = ref.read(bookmarkProvider.notifier);
    final isBookmarked = bookmarkNotifier.isBookmarked(news.url);

    return InkWell(
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => NewsDetailScreen(news: news),
      //     ),
      //   );
      // },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ Image section (responsive with AspectRatio)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: AspectRatio(
                aspectRatio: 20 / 14,
                child: news.urlToImage != null
                    ? CachedNetworkImage(
                        imageUrl: news.urlToImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 30.sp,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Icon(
                          Icons.article,
                          size: 40.sp,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 10.h),

            /// ✅ Content Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Source and Date + Bookmark button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('dd-MMM-yyyy').format(news.publishedAt),
                      style: AppTextStyles.smallHindi.copyWith(
                        color: AppTheme.lightTextPrimary,
                      ),
                    ),
                    if (showBookmarkButton)
                      SizedBox(
                        width: 32.w,
                        height: 32.w,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Image.asset(
                            isBookmarked ? 'assets/icons/bookmarkActive.png' : 'assets/icons/bookmark.png',
                            width: 22.w,
                            height: 22.h,
                            fit: BoxFit.contain,
                          ),
                          onPressed: () {
                            bookmarkNotifier.toggleBookmark(news);
                          },
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 5.h),

                /// ✅ Title
                Text(
                  news.title,
                  style: AppTextStyles.heading3Hindi.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightTextPrimary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                /// ✅ Description (if available)
                if (news.description != null) ...[
                  SizedBox(height: 5.h),
                  Text(
                    removeHtmlTags(news.description!),
                    style: AppTextStyles.smallHindi.copyWith(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
