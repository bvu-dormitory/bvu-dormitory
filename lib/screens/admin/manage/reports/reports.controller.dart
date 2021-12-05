import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

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
              title: appLocalizations!.admin_manage_student_all,
              icon: const Icon(FluentIcons.people_24_regular),
              onPressed: () {},
            ),
            AppMenuGroupItem(
              title: appLocalizations!.admin_manage_student_active,
              icon: const Icon(AntDesign.Safety),
              onPressed: () {},
            ),
            AppMenuGroupItem(
              title: appLocalizations!.admin_manage_student_absent,
              icon: const Icon(AntDesign.close),
              onPressed: () {},
            ),
          ],
        ),
        AppMenuGroup(
          title: appLocalizations!.admin_manage_invoice,
          items: [
            AppMenuGroupItem(
              title: appLocalizations!.admin_reports_invoice_all,
              icon: const Icon(FluentIcons.border_all_24_regular),
              onPressed: () {},
            ),
            AppMenuGroupItem(
              title: appLocalizations!.admin_reports_invoice_not_completed,
              icon: const Icon(FluentIcons.apps_add_in_24_regular),
              onPressed: () {},
            ),
          ],
        ),
        AppMenuGroup(
          title: appLocalizations!.admin_manage_item,
          items: [
            AppMenuGroupItem(
              title: appLocalizations!.admin_reports_item_all,
              icon: const Icon(FluentIcons.border_all_24_regular),
              onPressed: () {},
            ),
            AppMenuGroupItem(
              title: appLocalizations!.admin_reports_item_not_attached,
              icon: const Icon(AntDesign.logout),
              onPressed: () {},
            ),
            AppMenuGroupItem(
              title: appLocalizations!.admin_reports_item_attached,
              icon: const Icon(AntDesign.login),
              onPressed: () {},
            ),
          ],
        ),
        AppMenuGroup(
          title: appLocalizations!.admin_manage_repair,
          items: [
            AppMenuGroupItem(
              title: appLocalizations!.admin_reports_repairs_all,
              icon: const Icon(FluentIcons.border_all_24_regular),
              onPressed: () {},
            ),
            AppMenuGroupItem(
              title: appLocalizations!.admin_reports_repairs_waiting,
              icon: const Icon(FluentIcons.clock_24_regular),
              onPressed: () {},
            ),
          ],
        ),
      ];
}
