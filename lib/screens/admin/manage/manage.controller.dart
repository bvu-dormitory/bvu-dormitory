import 'package:bvu_dormitory/app/constants/app.routes.dart';
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
        routeName: '1'),
    ManageIconItem(
        title: "Phòng",
        iconPath: 'lib/assets/icons/room-key.png',
        routeName: AppRoutes.adminRooms.name),
    ManageIconItem(
        title: "Dịch vụ",
        iconPath: 'lib/assets/icons/water-drop.png',
        routeName: '2'),
    ManageIconItem(
        title: "Tài sản",
        iconPath: 'lib/assets/icons/idea.png',
        routeName: '3'),
    ManageIconItem(
        title: "Hóa đơn",
        iconPath: 'lib/assets/icons/bill.png',
        routeName: '4'),
    ManageIconItem(
        title: "Thống kê",
        iconPath: 'lib/assets/icons/pie-chart-1.png',
        routeName: '5'),
  ];

  bool isSliverCollasped = false;
}
