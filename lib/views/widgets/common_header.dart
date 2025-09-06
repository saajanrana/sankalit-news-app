import 'package:Sankalit/core/theme.dart';
import 'package:Sankalit/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonHeader extends StatelessWidget {
  final bool showBackBtn;
  const CommonHeader({super.key, this.showBackBtn = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: showBackBtn ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showBackBtn)
          IconButton.filled(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppTheme.darkBackgroundColor),
              foregroundColor: WidgetStateProperty.all(AppTheme.lightBackgroundColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Center(
              child: Icon(
                Icons.arrow_back,
                color: AppTheme.lightBackgroundColor,
                size: 15.sp,
              ),
            ),
          ),

        /// 👇 Wrap logo with GestureDetector
        GestureDetector(
          onTap: () {
            // Example: Navigate to HomeScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainScreen(
                        initialIndex: 0,
                      )),
            );
          },
          child: Image.asset(
            "assets/sankalitLogo.png",
            width: 140.w,
          ),
        ),
      ],
    );
  }
}
