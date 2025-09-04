import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Sankalit/core/app_text_style.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:shimmer/shimmer.dart';

class ContactUsCard extends StatelessWidget {
  final String? editor;
  final String? email;
  final int? phone;
  final String? address;
  const ContactUsCard({super.key, this.editor, this.email, this.phone, this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppTheme.darkBackgroundColor.withOpacity(0.05),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelValueText(label: "Editor: ", value: editor),
            SizedBox(height: 10.h),
            LabelValueText(
              label: "Email: ",
              value: email,
              labelType: "email",
            ),
            SizedBox(height: 10.h),
            LabelValueText(
              label: "Phone: ",
              value: phone.toString(),
              labelType: "phone",
            ),
            SizedBox(height: 10.h),
            LabelValueText(label: "Address: ", value: address),
          ],
        ),
      ),
    );
  }
}

// --------- Label and Values of contact us card widget ----- //
class LabelValueText extends StatelessWidget {
  final String label;
  final String? value;
  final String labelType;

  const LabelValueText({super.key, required this.label, this.value, this.labelType = "text"});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label ",
            style: AppTextStyles.bodyBold,
          ),
          value == null || value == "null"
              ? WidgetSpan(
                  child: Shimmer.fromColors(
                  baseColor: AppTheme.darkTextSecondary,
                  highlightColor: AppTheme.lightBackgroundColor,
                  child: Container(
                    height: 10.h,
                    width: 200.w,
                    decoration: BoxDecoration(
                      color: AppTheme.darkTextSecondary,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ))
              : TextSpan(
                  text: value,
                  style: AppTextStyles.body.copyWith(
                      color: labelType == "text" ? null : AppTheme.primaryColor,
                      decoration: labelType == "text" ? TextDecoration.none : TextDecoration.underline,
                      decorationColor: AppTheme.primaryColor),
                ),
        ],
      ),
    );
  }
}
