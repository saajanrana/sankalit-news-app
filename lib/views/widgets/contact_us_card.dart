import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/app_text_style.dart';
import 'package:news_app/core/theme.dart';

class ContactUsCard extends StatelessWidget {
  const ContactUsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppTheme.darkBackgroundColor.withOpacity(0.05),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 20.h, horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelValueText(label: "Editor: ", value: "Krishna pant"),
            SizedBox(height: 10.h),
            LabelValueText(
              label: "Email: ",
              value: "sankalit18@gmail.com",
              labelType: "email",
            ),
            SizedBox(height: 10.h),
            LabelValueText(
              label: "Phone: ",
              value: "+91 9720711889",
              labelType: "phone",
            ),
            SizedBox(height: 10.h),
            LabelValueText(label: "Address: ", value: "35, Panditwari, Premnagar, Dehradun, Uttarakhand - 248007"),
          ],
        ),
      ),
    );
  }
}

// --------- Label and Values of contact us card widget ----- //
class LabelValueText extends StatelessWidget {
  final String label;
  final String value;
  final String labelType;

  const LabelValueText({super.key, required this.label, required this.value, this.labelType = "text"});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label ",
            style: AppTextStyles.bodyBold,
          ),
          TextSpan(
            text: value,
            style: AppTextStyles.body.copyWith(
                color: labelType == "text" ? null : AppTheme.primaryColor, decoration: labelType == "text" ? TextDecoration.none : TextDecoration.underline, decorationColor: AppTheme.primaryColor),
          ),
        ],
      ),
    );
  }
}
