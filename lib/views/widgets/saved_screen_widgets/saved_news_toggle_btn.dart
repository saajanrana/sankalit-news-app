import 'package:sankalit/core/app_text_style.dart';
import 'package:sankalit/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedNewsToggleBtn extends StatefulWidget {
  final bool isTextNewsIsSelected;
  final VoidCallback onVideoBtnPress;
  final VoidCallback onNewsBtnPress;
  const SavedNewsToggleBtn({super.key, required this.isTextNewsIsSelected, required this.onNewsBtnPress, required this.onVideoBtnPress});

  @override
  State<SavedNewsToggleBtn> createState() => _SavedNewsToggleBtnState();
}

class _SavedNewsToggleBtnState extends State<SavedNewsToggleBtn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: widget.onNewsBtnPress,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(color: widget.isTextNewsIsSelected ? AppTheme.primaryColor : AppTheme.darkBackgroundColor.withOpacity(0.10), borderRadius: BorderRadius.circular(4.r)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Text("NEWS",
                      style: widget.isTextNewsIsSelected ? AppTextStyles.small.copyWith(color: AppTheme.lightBackgroundColor) : AppTextStyles.small.copyWith(color: AppTheme.darkBackgroundColor)),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: InkWell(
              onTap: widget.onVideoBtnPress,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(color: widget.isTextNewsIsSelected ? AppTheme.darkBackgroundColor.withOpacity(0.10) : AppTheme.primaryColor, borderRadius: BorderRadius.circular(4.r)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Text("VIDEOS", style: AppTextStyles.small.copyWith(color: widget.isTextNewsIsSelected ? AppTheme.darkBackgroundColor : AppTheme.lightBackgroundColor)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
