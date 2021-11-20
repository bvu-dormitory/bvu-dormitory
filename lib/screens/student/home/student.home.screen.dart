import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/screens/student/home/student.home.controller.dart';

class StudentHomeScreen extends BaseScreen<StudentHomeController> {
  StudentHomeScreen({Key? key}) : super(key: key, haveNavigationBar: false);

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  StudentHomeController provideController(BuildContext context) {
    return StudentHomeController(context: context, title: '');
  }

  @override
  Widget body(BuildContext context) {
    final controller = context.read<StudentHomeController>();

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        // backgroundColor: Colors.transparent,
        iconSize: 22,
        currentIndex: 0,
        activeColor: AppColor.mainColor,
        items: List.generate(controller.navItemsList.length, (index) {
          return _bottomNavBarItem(controller, index);
        }),
      ),
      tabBuilder: (context, index) {
        return controller.navItemsList[index].screen;
      },
    );
  }

  BottomNavigationBarItem _bottomNavBarItem(StudentHomeController controller, int index) {
    return BottomNavigationBarItem(
      // label: controller.navItemsList[index].title,
      title: Container(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(
          controller.navItemsList[index].title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Icon(controller.navItemsList[index].icon),
            top: 7,
          )
        ],
      ),
      activeIcon: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Icon(controller.navItemsList[index].activeIcon),
            top: 7,
          )
        ],
      ),
    );
  }
}
