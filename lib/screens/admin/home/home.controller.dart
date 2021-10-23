import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/manage.screen.dart';
import 'package:bvu_dormitory/screens/shared/messages/messages.screen.dart';
import 'package:bvu_dormitory/screens/shared/newsfeed/newsfeed.screen.dart';
import 'package:bvu_dormitory/screens/shared/profile/profile.screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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
  AdminHomeController({
    required BuildContext context,
    required String title,
  }) : super(title: title, context: context) {
    // notifyListeners();
    _pageController = PageController(
      initialPage: currentNavBarIndex,
      keepPage: true,
    );

    // tabController = CupertinoTabController(initialIndex: currentNavBarIndex);
  }

  late final PageController _pageController;
  PageController get pageController => _pageController;

  // late final CupertinoTabController tabController;

  int _currentNavBarIndex = 0;
  int get currentNavBarIndex => _currentNavBarIndex;
  set currentNavBarIndex(int index) {
    _currentNavBarIndex = index;
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 150), curve: Curves.ease);
    notifyListeners();
  }

  List<Widget> get getNavItemScreens => [
        AdminManageScreen(),
        NewsFeedScreen(),
        MessagesScreen(),
        // ProfileScreen(),
      ];

  List<HomeBottomNavItem> get navItemDataList => [
        HomeBottomNavItem(
          title: appLocalizations?.home_screen_navbar_item_manage ?? "Quản lí",
          icon: const Icon(FluentIcons.grid_24_regular),
          activeIcon: const Icon(FluentIcons.grid_24_filled),
        ),
        HomeBottomNavItem(
          title:
              appLocalizations?.home_screen_navbar_item_newsfeed ?? "Bảng tin",
          icon: const Icon(FluentIcons.news_24_regular),
          activeIcon: const Icon(FluentIcons.news_24_filled),
        ),
        HomeBottomNavItem(
          title: appLocalizations?.home_screen_navbar_item_chat ?? "Tin nhắn",
          icon: const Icon(CupertinoIcons.chat_bubble),
          activeIcon: const Icon(CupertinoIcons.chat_bubble_fill),
        ),
        // HomeBottomNavItem(
        //   title: appLocalizations?.home_screen_navbar_item_profile ?? "Cá nhân",
        //   icon: const Icon(CupertinoIcons.profile_circled),
        //   // activeIcon: const Icon(CupertinoIcons.profi),
        // ),
      ];
}
