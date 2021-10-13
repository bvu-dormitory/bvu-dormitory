import 'package:bvu_dormitory/base/base.controller.dart';
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

class StudentHomeController extends BaseController {
  StudentHomeController({required BuildContext context})
      : super(context: context);

  int _currentNavBarIndex = 0;
  int get currentNavBarIndex => _currentNavBarIndex;
  set currentNavBarIndex(int index) {
    _currentNavBarIndex = index;
    notifyListeners();
  }

  List<HomeBottomNavItem> get navItemDataList => [
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
          title: appLocalizations?.home_screen_navbar_item_room ?? "Phòng",
          icon: const Icon(CupertinoIcons.home),
          // activeIcon: Icon(CupertinoIcons.home),
        ),
        HomeBottomNavItem(
          title: appLocalizations?.home_screen_navbar_item_notifications ??
              "Thông báo",
          icon: const Icon(CupertinoIcons.bell),
          activeIcon: const Icon(CupertinoIcons.bell_solid),
        ),
        HomeBottomNavItem(
          title: appLocalizations?.home_screen_navbar_item_profile ?? "Cá nhân",
          icon: const Icon(CupertinoIcons.profile_circled),
          // activeIcon: const Icon(CupertinoIcons.profi),
        ),
      ];
}
