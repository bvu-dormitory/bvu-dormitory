import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:flutter/material.dart';

class ManageIconItem {
  String title;
  String iconPath;
  String routeName;

  ManageIconItem({
    required this.title,
    required this.iconPath,
    required this.routeName,
  });
}

class AdminManageController extends BaseController {
  AdminManageController({required BuildContext context})
      : super(context: context);

  List<ManageIconItem> menuItems = [
    ManageIconItem(
        title: "Sinh viên",
        iconPath: 'lib/assets/icons/profile.png',
        routeName: ''),
    ManageIconItem(
        title: "Phòng",
        iconPath: 'lib/assets/icons/room-key.png',
        routeName: ''),
    ManageIconItem(
        title: "Dịch vụ",
        iconPath: 'lib/assets/icons/water-drop.png',
        routeName: ''),
    ManageIconItem(
        title: "Tài sản", iconPath: 'lib/assets/icons/idea.png', routeName: ''),
    ManageIconItem(
        title: "Hóa đơn", iconPath: 'lib/assets/icons/bill.png', routeName: ''),
    ManageIconItem(
        title: "Thống kê",
        iconPath: 'lib/assets/icons/pie-chart.png',
        routeName: ''),
  ];
}
