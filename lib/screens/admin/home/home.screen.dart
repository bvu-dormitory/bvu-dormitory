import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/screens/admin/home/home.controller.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends BaseScreen<AdminHomeController> {
  AdminHomeScreen({Key? key}) : super(key: key, haveNavigationBar: false);

  @override
  AdminHomeController provideController(BuildContext context) {
    return AdminHomeController(context: context, title: "");
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    final controller = context.watch<AdminHomeController>();

    // return Scaffold(
    //   body: PageView.builder(
    //     controller: controller.pageController,
    //     physics: const NeverScrollableScrollPhysics(),
    //     itemCount: controller.getNavItemScreens.length,
    //     itemBuilder: (context, index) {
    //       return controller.getNavItemScreens[index];
    //     },
    //   ),
    //   bottomNavigationBar: BottomNavigationBar(
    //     currentIndex: controller.currentNavBarIndex,
    //     onTap: (index) {
    //       controller.currentNavBarIndex = index;
    //     },
    //     type: BottomNavigationBarType.fixed,
    //     unselectedLabelStyle: const TextStyle(
    //       color: Colors.black,
    //       fontSize: 11,
    //       fontWeight: FontWeight.bold,
    //     ),
    //     selectedLabelStyle: const TextStyle(
    //       fontSize: 11,
    //       fontWeight: FontWeight.bold,
    //     ),
    //     items: List.generate(
    //       controller.navItemDataList.length,
    //       (index) => _bottomNavBarItem(controller, index),
    //     ),
    //   ),
    // );

    return CupertinoTabScaffold(
      backgroundColor: Colors.transparent,
      tabBar: CupertinoTabBar(
        iconSize: 22,
        backgroundColor: Colors.white.withOpacity(0.85),
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
