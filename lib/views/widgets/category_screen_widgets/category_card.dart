import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sankalit/core/app_text_style.dart';
import 'package:sankalit/core/theme.dart';

class CategoryCard extends StatelessWidget {
  final VoidCallback onTap;
  final String tileTitle;
  final bool didHaveSubCategory;
  final bool subCategoryIsOpen;
  final bool isSelected;

  const CategoryCard({super.key, required this.onTap, required this.tileTitle, this.didHaveSubCategory = false, this.subCategoryIsOpen = false, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppTheme.darkBackgroundColor.withOpacity(0.9) : AppTheme.darkBackgroundColor.withOpacity(0.04),
      borderRadius: BorderRadius.circular(5.r),
      child: InkWell(
        onTap: onTap,
        splashColor: isSelected ? AppTheme.lightBackgroundColor.withOpacity(0.3) : AppTheme.darkBackgroundColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(5.r),
        child: Container(
          width: double.infinity,
          height: 35.h,
          decoration:
              BoxDecoration(color: AppTheme.darkBackgroundColor.withOpacity(0.04), borderRadius: BorderRadius.circular(5.r), border: Border.all(color: AppTheme.darkBackgroundColor.withOpacity(0.3))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  tileTitle,
                  style: AppTextStyles.bodyHindi.copyWith(
                    color: isSelected ? AppTheme.lightBackgroundColor : AppTheme.darkBackgroundColor,
                  ),
                ),
                didHaveSubCategory
                    ? subCategoryIsOpen
                        ? SvgPicture.asset(
                            "assets/icons/arrowTop.svg",
                            width: 14.w,
                            height: 14.h,
                            color: isSelected ? AppTheme.lightBackgroundColor : AppTheme.darkBackgroundColor,
                          )
                        : SvgPicture.asset(
                            "assets/icons/arrowBottom.svg",
                            width: 14.w,
                            height: 14.h,
                            color: isSelected ? AppTheme.lightBackgroundColor : AppTheme.darkBackgroundColor,
                          )
                    : SvgPicture.asset(
                        "assets/icons/arrowRight.svg",
                        width: 14.w,
                        height: 14.h,
                        color: isSelected ? AppTheme.lightBackgroundColor : AppTheme.darkBackgroundColor,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
