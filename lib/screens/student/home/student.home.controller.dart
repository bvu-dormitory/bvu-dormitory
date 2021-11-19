import 'package:bvu_dormitory/screens/shared/profile/profile.screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/screens/shared/messages/messages.screen.dart';
import 'package:bvu_dormitory/screens/shared/newsfeed/newsfeed.screen.dart';
import 'package:bvu_dormitory/screens/student/room/student.room.screen.dart';

class HomeBottomNavItem {
  String title;
  IconData icon;
  IconData? activeIcon;
  Widget screen;

  HomeBottomNavItem({
    required this.title,
    required this.icon,
    required this.screen,
    this.activeIcon,
  });
}

class StudentHomeController extends BaseController {
  StudentHomeController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  int _currentNavBarIndex = 0;
  int get currentNavBarIndex => _currentNavBarIndex;
  set currentNavBarIndex(int index) {
    _currentNavBarIndex = index;
    // pageController.jumpToPage(index);
    notifyListeners();
  }

  // PageController pageController = PageController(initialPage: 0);

  List<HomeBottomNavItem> get navItemsList => [
        HomeBottomNavItem(
          title: appLocalizations!.home_screen_navbar_item_room,
          icon: FluentIcons.home_24_regular,
          screen: StudentRoomScreen(),
          activeIcon: FluentIcons.home_24_filled,
        ),
        HomeBottomNavItem(
          title: appLocalizations!.home_screen_navbar_item_newsfeed,
          icon: FluentIcons.news_24_regular,
          activeIcon: FluentIcons.news_24_filled,
          screen: NewsFeedScreen(),
        ),
        HomeBottomNavItem(
          title: appLocalizations!.home_screen_navbar_item_chat,
          icon: FluentIcons.chat_24_regular,
          activeIcon: FluentIcons.chat_24_filled,
          screen: MessagesScreen(),
        ),
        HomeBottomNavItem(
          title: appLocalizations!.home_screen_navbar_item_profile,
          icon: FluentIcons.person_24_regular,
          activeIcon: FluentIcons.person_24_filled,
          screen: ProfileScreen(),
        ),
      ];
}
