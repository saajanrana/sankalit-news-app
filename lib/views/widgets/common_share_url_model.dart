import 'package:Sankalit/core/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

void showShareModal(BuildContext context, url) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Share This News",
              style: AppTextStyles.heading2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            // Row of app icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _shareIcon('assets/icons/facebookIcon.png', "Facebook", () async {
                  final fbUrl = Uri.parse("https://www.facebook.com/sharer/sharer.php?u=$url");
                  if (await canLaunchUrl(fbUrl)) {
                    await launchUrl(fbUrl, mode: LaunchMode.externalApplication);
                  }
                }),
                _shareIcon('assets/icons/xIcon.png', "X", () async {
                  final twitterUrl = Uri.parse("https://twitter.com/intent/tweet?text=Check out this news&url=$url");
                  if (await canLaunchUrl(twitterUrl)) {
                    await launchUrl(twitterUrl, mode: LaunchMode.externalApplication);
                  }
                  Navigator.pop(context);
                }),
                _shareIcon('assets/icons/whatsappIcon.png', "WhatsApp", () async {
                  final whatsappUrl = Uri.parse("https://wa.me/?text=Check out this news! $url");
                  if (await canLaunchUrl(whatsappUrl)) {
                    await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                  }

                  Navigator.pop(context);
                }),
                _shareIcon('assets/icons/gmailIcon.png', "Gmail", () async {
                  try {
                    final String subject = Uri.encodeComponent("Check out this news!");
                    final String body = Uri.encodeComponent(url);

                    final Uri emailUri = Uri.parse("mailto:?subject=$subject&body=$body");

                    if (await canLaunchUrl(emailUri)) {
                      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
                    } else {
                      print("No email client found.");
                    }
                  } catch (e) {
                    print("error:::$e");
                  }
                }),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget _shareIcon(String iconPath, String label, VoidCallback onTap) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: Image.asset(
          iconPath,
          height: 30.h,
          width: 30.w,
        ),
        onPressed: onTap,
      ),
      Text(
        label,
        style: AppTextStyles.small,
      ),
    ],
  );
}
