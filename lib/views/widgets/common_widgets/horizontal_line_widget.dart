import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/theme.dart';

class HorizontalLineWidget extends StatelessWidget {
  const HorizontalLineWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1.h,
      decoration: BoxDecoration(color: AppTheme.darkBackgroundColor.withOpacity(0.20)),
    );
  }
}
