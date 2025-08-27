import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../models/news_model.dart';
import '../../viewmodels/bookmark_viewmodel.dart';
import '../screens/news_detail_screen.dart';

class NewsCard extends ConsumerWidget {
  final NewsModel news;
  final bool showBookmarkButton;

  const NewsCard({
    super.key,
    required this.news,
    this.showBookmarkButton = true,
  });
  String limitWords(String text, int wordLimit) {
    final words = text.split(' ');
    if (words.length <= wordLimit) return text;
    return words.take(wordLimit).join(' ') + '...';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkNotifier = ref.read(bookmarkProvider.notifier);
    final isBookmarked = bookmarkNotifier.isBookmarked(news.url);
  

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(news: news),
          ),
        );
      },
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
                child: news.urlToImage != null
                    ? CachedNetworkImage(
                        imageUrl: news.urlToImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
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
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
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
                padding: EdgeInsets.all(12.w),
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
                            limitWords(news.title, 18),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                  fontSize: 16.sp,
                                ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Description (if available)
                          if (news.description != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              limitWords(news.description!, 30),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7),
                                    height: 1.3,
                                    fontSize: 14.sp,
                                  ),
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
                              // // Source
                              // Text(
                              //   "news.state",
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .bodySmall
                              //       ?.copyWith(
                              //         color:
                              //             Theme.of(context).colorScheme.primary,
                              //         fontWeight: FontWeight.w500,
                              //         fontSize: 14.sp,
                              //       ),
                              //   overflow: TextOverflow.ellipsis,
                              // ),

                              SizedBox(width: 10.w),
                              Text(
                                DateFormat('dd-MMM-yyyy')
                                    .format(news.publishedAt),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                                      fontSize: 13.sp,
                                    ),
                              ),
                            ],
                          ),
                        ),

                        // Right side - Bookmark button
                        if (showBookmarkButton)
                          Container(
                            width: 32.w,
                            height: 32.h,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Image.asset(
                                isBookmarked
                                    ? 'assets/icons/bookmarkActive.png'
                                    : 'assets/icons/bookmark.png',
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkNotifier = ref.read(bookmarkProvider.notifier);
    final isBookmarked = bookmarkNotifier.isBookmarked(news.url);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(news: news),
          ),
        );
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            SizedBox(
              height: 100.h,
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: news.urlToImage != null
                        ? CachedNetworkImage(
                            imageUrl: news.urlToImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            placeholder: (context, url) => Container(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              child: const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              child: Icon(
                                Icons.image_not_supported,
                                size: 30.sp,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          )
                        : Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: Icon(
                              Icons.article,
                              size: 40.sp,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                  ),
                ],
              ),
            ),

            // Content section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Source and Date row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text(
                    //   // news.state,
                    //   'dfdsf',
                    //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    //         color: Theme.of(context).colorScheme.primary,
                    //         fontWeight: FontWeight.w600,
                    //         fontSize: 12.sp,
                    //       ),
                    // ),
                    Text(
                      DateFormat('dd-MMM-yyyy').format(news.publishedAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                            fontSize: 12.sp,
                          ),
                    ),
                    // Bookmark button positioned on image
                    if (showBookmarkButton)
                     Container(
                            width: 32.w,
                            height: 32.h,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Image.asset(
                                isBookmarked
                                    ? 'assets/icons/bookmarkActive.png'
                                    : 'assets/icons/bookmark.png',
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
                SizedBox(height: 8.h),
                // Title
                Text(
                  news.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                // Description (if available)
                if (news.description != null) ...[
                  SizedBox(height: 6.h),
                  Text(
                    news.description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                          height: 1.4,
                          fontSize: 12.sp,
                        ),
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
