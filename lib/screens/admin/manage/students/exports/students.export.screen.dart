import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/students/exports/students.exports.controller.dart';

class AdminStudentsExportScreen
    extends BaseScreen<AdminStudentsExportsController> {
  AdminStudentsExportScreen({
    Key? key,
    required String previousPageTitle,
  }) : super(key: key, previousPageTitle: previousPageTitle);

  @override
  AdminStudentsExportsController provideController(BuildContext context) {
    return AdminStudentsExportsController(
      context: context,
      title: AppLocalizations.of(context)
              ?.admin_manage_student_menu_export_excel ??
          "admin_manage_student_menu_export_excel",
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    final AdminStudentsExportsController controller =
        context.read<AdminStudentsExportsController>();

    return SafeArea(
        child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: AppMenuGroup(
        items: controller.menuItems,
      ),
    ));
  }
}
