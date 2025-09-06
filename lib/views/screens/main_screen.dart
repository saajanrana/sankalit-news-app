import 'package:Sankalit/core/constants.dart';
import 'package:Sankalit/core/theme.dart';
import 'package:Sankalit/views/screens/contact_us_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bookmarks_screen.dart';
import 'categories_screen.dart';
import 'home_screen.dart';
import 'video_news_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const VideoNewsScreen(),
    const BookmarksScreen(),
    const ContactUsScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: AppStrings.home,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.category),
      label: AppStrings.categories,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.play_circle),
      label: AppStrings.videoNews,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.bookmark),
      label: AppStrings.bookmarks,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.call),
      label: AppStrings.contactUs,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildCustomNavBar(),
    );
  }

  Widget _buildCustomNavBar() {
    return Container(
      height: 75.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          // Customizable properties

          items: _navItems.map((item) {
            return BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(2.sp),
                child: Icon(
                  (item.icon as Icon).icon,
                  size: 20.sp,
                  color: _currentIndex == _navItems.indexOf(item) ? AppTheme.primaryColor : AppTheme.lightBackgroundColor,
                ),
              ),
              label: item.label,
              backgroundColor: AppTheme.bottomBarDarkColor,
            );
          }).toList(),
          type: BottomNavigationBarType.fixed,
          elevation: 4,
          backgroundColor: AppTheme.bottomBarDarkColor,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.lightBackgroundColor,
          selectedFontSize: 12.sp,
          unselectedFontSize: 10.sp,
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
