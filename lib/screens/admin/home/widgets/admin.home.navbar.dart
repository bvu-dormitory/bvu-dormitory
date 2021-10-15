import 'package:bvu_dormitory/screens/admin/home/admin.home.controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHomeBottomNavbar extends StatefulWidget {
  AdminHomeBottomNavbar({Key? key}) : super(key: key);

  @override
  _AdminHomeBottomNavbarState createState() => _AdminHomeBottomNavbarState();
}

class _AdminHomeBottomNavbarState extends State<AdminHomeBottomNavbar> {
  late AdminHomeController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<AdminHomeController>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.getNavItemScreens.length,
        itemBuilder: (context, index) {
          return controller.getNavItemScreens[index];
        },
        onPageChanged: (index) {
          // controller.currentNavBarIndex = index;
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
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
