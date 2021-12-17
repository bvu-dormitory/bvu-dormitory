import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/screens/shared/profile/profile.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/manage.screen.dart';
import 'package:bvu_dormitory/screens/shared/messages/messages.screen.dart';
import 'package:bvu_dormitory/screens/shared/newsfeed/newsfeed.screen.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class HomeBottomNavItem {
  String title;
  IconData icon;
  IconData? activeIcon;

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
    required this.user,
  }) : super(title: title, context: context) {
    // notifyListeners();
    _pageController = PageController(
      initialPage: currentNavBarIndex,
      keepPage: true,
    );

    // tabController = CupertinoTabController(initialIndex: currentNavBarIndex);
  }

  final AppUser user;

  late final PageController _pageController;
  PageController get pageController => _pageController;

  // late final CupertinoTabController tabController;

  int _currentNavBarIndex = 0;
  int get currentNavBarIndex => _currentNavBarIndex;
  set currentNavBarIndex(int index) {
    _currentNavBarIndex = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }

  List<Widget> get getNavItemScreens => [
        AdminManageScreen(user: user),
        NewsFeedScreen(user: user),
        MessagesScreen(user: user),
        ProfileScreen(user: user),
      ];

  List<HomeBottomNavItem> get navItemDataList => [
        HomeBottomNavItem(
          title: appLocalizations!.home_screen_navbar_item_manage,
          icon: FluentIcons.grid_24_regular,
          activeIcon: FluentIcons.grid_24_filled,
        ),
        HomeBottomNavItem(
          title: appLocalizations!.home_screen_navbar_item_newsfeed,
          icon: Ionicons.notifications_outline,
          activeIcon: Ionicons.notifications,
        ),
        HomeBottomNavItem(
          title: appLocalizations!.home_screen_navbar_item_chat,
          icon: CupertinoIcons.chat_bubble,
          activeIcon: CupertinoIcons.chat_bubble_fill,
        ),
        HomeBottomNavItem(
          title: appLocalizations!.home_screen_navbar_item_profile,
          icon: FluentIcons.person_24_regular,
          activeIcon: FluentIcons.person_24_filled,
        ),
      ];
}
