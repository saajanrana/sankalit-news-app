import 'package:sankalit/core/app_text_style.dart';
import 'package:sankalit/core/theme.dart';
import 'package:sankalit/services/api_services.dart';
import 'package:sankalit/views/screens/main_screen.dart';
import 'package:sankalit/views/widgets/common_header.dart';
import 'package:sankalit/views/widgets/contact_us_card.dart';
import 'package:sankalit/views/widgets/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  Map<String, dynamic> contactUsDetails = {};
  Map<String, dynamic> socialLinks = {};
  loadData() async {
    try {
      final response = await ApiServices.get(endpoint: 'contact-us');
      if (response.containsKey("noInternet") && response["noInternet"] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NoInternetWidget(
              onRetry: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen(initialIndex: 4)),
                );
              },
            ),
          ),
        );
        return;
      }
      if (response['success']) {
        setState(() {
          contactUsDetails = response['data'];
          socialLinks = response['data']['socialLinks'];
        });
      }
    } catch (e) {
      print("something went wrong in loadData in contact us Screen::$e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.lightBackgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              const CommonHeader(),
              SizedBox(height: 20.h),
              const Text(
                "CONTACT US",
                style: AppTextStyles.heading2,
              ),
              SizedBox(height: 10.h),
              ContactUsCard(
                editor: contactUsDetails['editorName'],
                email: contactUsDetails['email'],
                phone: contactUsDetails['phone'],
                address: contactUsDetails['address'],
              ),
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
                    onTap: socialLinks.isEmpty || socialLinks['facebook'] == null
                        ? null
                        : () async {
                            final Uri url = Uri.parse(socialLinks['facebook']);

                            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                              throw Exception("Could not launch $url");
                            }
                          },
                    child: Image.asset(
                      "assets/icons/facebookIcon.png",
                      width: 40.w,
                      height: 40.h,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  InkWell(
                    onTap: socialLinks.isEmpty || socialLinks['twitter'] == null
                        ? null
                        : () async {
                            final Uri url = Uri.parse(socialLinks['twitter']);

                            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                              throw Exception("Could not launch $url");
                            }
                          },
                    child: Image.asset(
                      "assets/icons/xIcon.png",
                      width: 40.w,
                      height: 40.h,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  InkWell(
                    onTap: socialLinks.isEmpty || socialLinks['youtube'] == null
                        ? null
                        : () async {
                            final Uri url = Uri.parse(socialLinks['youtube']);

                            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                              throw Exception("Could not launch $url");
                            }
                          },
                    child: Image.asset(
                      "assets/icons/youtubeIcon.png",
                      width: 40.w,
                      height: 40.h,
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
