import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/screens/admin/home/home.controller.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends BaseScreen<AdminHomeController> {
  AdminHomeScreen({Key? key, required this.user}) : super(key: key, haveNavigationBar: false);

  final AppUser user;

  @override
  AdminHomeController provideController(BuildContext context) {
    return AdminHomeController(context: context, title: "", user: user);
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    final controller = context.watch<AdminHomeController>();

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: controller.currentNavBarIndex,
        iconSize: 22,
        activeColor: AppColor.mainColor(context.watch<AppController>().appThemeMode),
        items: List.generate(
          controller.navItemDataList.length,
          (index) => _bottomNavBarItem(controller, index),
        ),
      ),
      // controller: controller.tabController,
      tabBuilder: (context, index) {
        return controller.getNavItemScreens[index];
      },
    );
  }

  BottomNavigationBarItem _bottomNavBarItem(AdminHomeController controller, int index) {
    return BottomNavigationBarItem(
      // label: controller.navItemDataList[index].title,
      title: Container(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(
          controller.navItemDataList[index].title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Icon(controller.navItemDataList[index].icon),
            top: 7,
          )
        ],
      ),
      activeIcon: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Icon(controller.navItemDataList[index].activeIcon),
            top: 7,
          )
        ],
      ),
    );
  }
}
