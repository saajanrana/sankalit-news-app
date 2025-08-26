import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/theme.dart';
import 'package:news_app/views/screens/contact_us_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'video_news_screen.dart';
import 'bookmarks_screen.dart';
import '../../core/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PersistentTabController _controller = PersistentTabController();

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      padding: EdgeInsets.symmetric(vertical: 3.sp),

      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      // confineInSafeArea: true,

      confineToSafeArea: true,
      backgroundColor: AppTheme.lightBackgroundColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      // hideNavigationBarWhenKeyboardShows: true,
      hideNavigationBarWhenKeyboardAppears: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(0),
        colorBehindNavBar: Theme.of(context).colorScheme.surface,
      ),
      // popAllScreensOnTapOfSelectedTab: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      animationSettings: const NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          )),
      navBarStyle: NavBarStyle.style6,
    );
  }

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const CategoriesScreen(),
      const VideoNewsScreen(),
      const BookmarksScreen(),
      const ContactUsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: AppStrings.home,
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.category),
        title: AppStrings.categories,
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.play_circle),
        title: AppStrings.videoNews,
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.bookmark),
        title: AppStrings.bookmarks,
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.call),
        title: AppStrings.contactUs,
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
    ];
  }
}
