import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/app_text_style.dart';
import 'package:news_app/core/theme.dart';
import 'package:news_app/views/widgets/common_header.dart';
import 'package:news_app/views/widgets/saved_screen_widgets/saved_news_toggle_btn.dart';
import 'package:news_app/views/widgets/video_screen_widgets/video_news_card.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  bool isTextNewsIsSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.lightBackgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            const CommonHeader(),
            SizedBox(height: 20.h),
            const Text(
              "SAVED",
              style: AppTextStyles.heading2,
            ),
            SizedBox(height: 20.h),
            SavedNewsToggleBtn(
              isTextNewsIsSelected: isTextNewsIsSelected,
              onNewsBtnPress: () {
                if (!isTextNewsIsSelected) {
                  setState(() {
                    isTextNewsIsSelected = true;
                  });
                }
              },
              onSaveBtnPress: () {
                if (isTextNewsIsSelected) {
                  setState(() {
                    isTextNewsIsSelected = false;
                  });
                }
              },
            ),
            SizedBox(height: 20.h),
            Expanded(
                child: ListView.builder(
              padding: EdgeInsets.all(0),
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
            ))
          ],
        ),
      ),
    ));
  }
}
