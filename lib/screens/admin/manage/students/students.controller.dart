import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/buildings/buildings.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/students/exports/students.export.screen.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';

class AdminStudentsController extends BaseController {
  AdminStudentsController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  List<AppMenuGroupItem> get menuItems => [
        AppMenuGroupItem(
          title: appLocalizations?.admin_manage_student_menu_add ?? "admin_manage_student_menu_add",
          icon: FluentIcons.person_add_24_regular,
          onPressed: () {
            navigator.push(
              CupertinoPageRoute(
                builder: (context) => AdminBuildingsScreen(previousPageTitle: title),
              ),
            );
          },
        ),
        AppMenuGroupItem(
            title: appLocalizations?.admin_manage_student_menu_export_excel ?? "admin_manage_student_menu_export_excel",
            icon: FluentIcons.sign_out_24_regular,
            onPressed: () {
              navigator.push(
                CupertinoPageRoute(
                  builder: (context) => AdminStudentsExportScreen(previousPageTitle: title),
                ),
              );
            }),
      ];
}
