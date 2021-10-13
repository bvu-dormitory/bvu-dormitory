import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../student.home.controller.dart';

class StudentHomeBottomNavbar extends StatefulWidget {
  StudentHomeBottomNavbar({Key? key}) : super(key: key);

  @override
  _StudentHomeBottomNavbarState createState() =>
      _StudentHomeBottomNavbarState();
}

class _StudentHomeBottomNavbarState extends State<StudentHomeBottomNavbar> {
  late StudentHomeController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<StudentHomeController>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: controller.currentNavBarIndex,
      onTap: (index) {
        controller.currentNavBarIndex = index;
      },
      type: BottomNavigationBarType.fixed,
      unselectedLabelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
      selectedLabelStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
      items: List.generate(
        controller.navItemDataList.length,
        (index) => _bottomNavBarItem(index),
      ),
    );
  }

  BottomNavigationBarItem _bottomNavBarItem(int index) {
    return BottomNavigationBarItem(
      // label: controller.navItemDataList[index].title,
      title: Container(
        padding: const EdgeInsets.only(top: 5),
        child: Text(controller.navItemDataList[index].title),
      ),
      icon: controller.navItemDataList[index].icon,
      activeIcon: controller.navItemDataList[index].activeIcon,
    );
  }
}
