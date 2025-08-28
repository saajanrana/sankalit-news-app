import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:Sankalit/views/widgets/common_header.dart';
import 'package:Sankalit/views/widgets/contact_us_card.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
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
                "CONTACT US",
                style: AppTextStyles.heading2,
              ),
              SizedBox(height: 10.h),
              const ContactUsCard(),
              SizedBox(height: 10.h),
              const Text(
                "STAY CONNECTED",
                style: AppTextStyles.heading2,
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      final Uri url = Uri.parse("https://www.facebook.com/sankalitnews");

                      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                        throw Exception("Could not launch $url");
                      }
                    },
                    child: Image.asset(
                      "assets/icons/facebookIcon.png",
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  InkWell(
                    child: Image.asset(
                      "assets/icons/xIcon.png",
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  InkWell(
                    onTap: () async {
                      final Uri url = Uri.parse("https://www.youtube.com/channel/UCmw22p0FRshQVHhSbzsr9Iw");

                      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                        throw Exception("Could not launch $url");
                      }
                    },
                    child: Image.asset(
                      "assets/icons/youtubeIcon.png",
                      width: 20.w,
                      height: 20.h,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
