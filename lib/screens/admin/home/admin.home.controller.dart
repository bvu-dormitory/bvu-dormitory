import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/manage.screen.dart';
import 'package:bvu_dormitory/screens/admin/reports/reports.screen.dart';
import 'package:bvu_dormitory/screens/shared/messages/messages.screen.dart';
import 'package:bvu_dormitory/screens/shared/newsfeed/newsfeed.screen.dart';
import 'package:bvu_dormitory/screens/shared/profile/profile.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeBottomNavItem {
  String title;
  Icon icon;
  Icon? activeIcon;

  HomeBottomNavItem({
    required this.title,
    required this.icon,
    this.activeIcon,
  });
}

class AdminHomeController extends BaseController {
  AdminHomeController({required BuildContext context})
      : super(context: context) {
    notifyListeners();
  }

  int _currentNavBarIndex = 0;
  int get currentNavBarIndex => _currentNavBarIndex;
  set currentNavBarIndex(int index) {
    _currentNavBarIndex = index;
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 150), curve: Curves.ease);
    notifyListeners();
  }

  final PageController _pageController = PageController();
  PageController get pageController => _pageController;

  List<Widget> getNavItemScreens = [
    AdminManageScreen(),
    NewsFeedScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  List<HomeBottomNavItem> get navItemDataList => [
        HomeBottomNavItem(
          title: appLocalizations?.home_screen_navbar_item_manage ?? "Quản lí",
          icon: const Icon(CupertinoIcons.home),
        ),
        HomeBottomNavItem(
          title:
              appLocalizations?.home_screen_navbar_item_newsfeed ?? "Bảng tin",
          icon: const Icon(CupertinoIcons.news),
          activeIcon: const Icon(CupertinoIcons.news_solid),
        ),
        HomeBottomNavItem(
          title: appLocalizations?.home_screen_navbar_item_chat ?? "Tin nhắn",
          icon: const Icon(CupertinoIcons.chat_bubble),
          activeIcon: const Icon(CupertinoIcons.chat_bubble_fill),
        ),
        HomeBottomNavItem(
          title: appLocalizations?.home_screen_navbar_item_profile ?? "Cá nhân",
          icon: const Icon(CupertinoIcons.profile_circled),
          // activeIcon: const Icon(CupertinoIcons.profi),
        ),
      ];
}
