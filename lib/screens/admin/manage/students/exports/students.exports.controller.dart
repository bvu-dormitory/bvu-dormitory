import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class AdminStudentsExportsController extends BaseController {
  AdminStudentsExportsController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  List<AppMenuGroupItem> get menuItems => [
        AppMenuGroupItem(
          title: appLocalizations?.admin_manage_student_menu_export_excel_all ??
              "admin_manage_student_menu_export_excel_all",
          icon: FluentIcons.people_24_regular,
          onPressed: () {},
        ),
        AppMenuGroupItem(
          title:
              appLocalizations?.admin_manage_student_menu_export_excel_active ??
                  "admin_manage_student_menu_export_excel_active",
          icon: AntDesign.Safety,
          onPressed: () {},
        ),
        AppMenuGroupItem(
          title:
              appLocalizations?.admin_manage_student_menu_export_excel_absent ??
                  "admin_manage_student_menu_export_excel_absent",
          icon: AntDesign.close,
          onPressed: () {},
        ),
      ];
}
