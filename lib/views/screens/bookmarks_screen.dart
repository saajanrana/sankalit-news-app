import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/app_text_style.dart';
import 'package:news_app/core/constants.dart';
import 'package:news_app/core/theme.dart';
import 'package:news_app/viewmodels/news_viewmodel.dart';
import 'package:news_app/views/widgets/common_header.dart';
import 'package:news_app/views/widgets/news_card.dart';
import 'package:news_app/views/widgets/saved_screen_widgets/saved_news_toggle_btn.dart';
import 'package:news_app/views/widgets/shimmer_loading.dart';
import 'package:news_app/views/widgets/video_screen_widgets/video_news_card.dart';


class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  bool isTextNewsIsSelected = true;

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.lightBackgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              const CommonHeader(),
              SizedBox(height: 20.h),
              const Text(
                "SAVED",
                style: AppTextStyles.heading2,
              ),
              SizedBox(height: 20.h),

              // Toggle Button
              SavedNewsToggleBtn(
                isTextNewsIsSelected: isTextNewsIsSelected,
                onNewsBtnPress: () {
                  setState(() {
                    isTextNewsIsSelected = true;
                  });
                },
                onVideoBtnPress: () {
                  setState(() {
                    isTextNewsIsSelected = false;
                  });
                },
              ),

              SizedBox(height: 20.h),

              // Content Area (News or Videos)
              Expanded(
                child: isTextNewsIsSelected
                    ? _buildNewsList(newsState)
                    : _buildVideoList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build News List
  Widget _buildNewsList(NewsState newsState) {
    if (newsState.isLoading && newsState.news.isEmpty) {
      return const ShimmerLoading();
    } else if (newsState.error != null && newsState.news.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
      );
    } else {
      return ListView.separated(
        itemCount: newsState.news.length,
        separatorBuilder: (_, __) => Divider(
          thickness: 1,
          color: Colors.grey.withOpacity(0.3),
          indent: 16.w,
          endIndent: 16.w,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: NewsCard(news: newsState.news[index]),
          );
        },
      );
    }
  }

  /// Build Video List
  Widget _buildVideoList() {
    return  Expanded(
                      child: ListView.builder(
                    padding: EdgeInsets.all(0.sp),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: VideoNewsCard( 
                          videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
                          videoNewsTitle: "बागेश्वर के हरबाड़ में भारी बारिश और भूस्खलन से तबाही, कई घर क्षतिग्रस्त",
                          dateString: "19-05-2025",
                          onPressSaveBtn: () {},
                          onPressShareBtn: () {},
                        ),
                      );
                    },
                  ));
  }
}
