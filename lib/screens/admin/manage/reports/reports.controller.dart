import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class AdminReportsController extends BaseController {
  AdminReportsController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  List<AppMenuGroup> get menuItems => [
        AppMenuGroup(
          title: appLocalizations!.admin_manage_student,
          items: [
            AppMenuGroupItem(
              title: appLocalizations?.admin_manage_student_menu_add ?? "admin_manage_student_menu_add",
              icon: const Icon(FluentIcons.person_add_24_regular),
              onPressed: () {},
            ),
            AppMenuGroupItem(
                title: appLocalizations?.admin_manage_student_menu_export_excel ??
                    "admin_manage_student_menu_export_excel",
                icon: const Icon(FluentIcons.sign_out_24_regular),
                onPressed: () {}),
          ],
        ),
      ];
}
