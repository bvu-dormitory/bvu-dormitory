import 'dart:developer';

import 'package:bvu_dormitory/app/constants/app.routes.dart';
import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/buildings/buildings.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/students/students.screen.dart';
import 'package:flutter/material.dart';

class ManageIconItem {
  String title;
  String iconPath;
  Widget screen;

  ManageIconItem({
    required this.title,
    required this.iconPath,
    required this.screen,
  });
}

class AdminManageController extends BaseController {
  AdminManageController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  late bool _isSliverCollasped = false;
  onSliverScroll(double height) {
    if (height >= 115) {
      if (!_isSliverCollasped) {
        _isSliverCollasped = true;
        notifyListeners();
      }
    } else {
      if (_isSliverCollasped) {
        _isSliverCollasped = false;
        notifyListeners();
      }
    }
  }

  List<ManageIconItem> get menuItems => [
        ManageIconItem(
          title:
              appLocalizations?.admin_manage_student ?? "admin_manage_student",
          iconPath: 'lib/assets/icons/profile.png',
          screen: AdminStudentsScreen(previousPageTitle: title),
        ),
        ManageIconItem(
          title: appLocalizations?.admin_manage_room ?? "admin_manage_room",
          iconPath: 'lib/assets/icons/room-key.png',
          screen: AdminBuildingsScreen(previousPageTitle: title),
        ),
        ManageIconItem(
          title:
              appLocalizations?.admin_manage_service ?? "admin_manage_services",
          iconPath: 'lib/assets/icons/water-drop.png',
          screen: AppRoutes.notFound.screen,
        ),
        ManageIconItem(
          title: appLocalizations?.admin_manage_item ?? "admin_manage_item",
          iconPath: 'lib/assets/icons/idea.png',
          screen: AppRoutes.notFound.screen,
        ),
        ManageIconItem(
          title:
              appLocalizations?.admin_manage_invoice ?? "admin_manage_invoice",
          iconPath: 'lib/assets/icons/bill.png',
          screen: AppRoutes.notFound.screen,
        ),
        ManageIconItem(
          title: appLocalizations?.admin_manage_stat ?? "admin_manage_stat",
          iconPath: 'lib/assets/icons/pie-chart-1.png',
          screen: AppRoutes.notFound.screen,
        ),
      ];

  bool isSliverCollasped = false;
}
