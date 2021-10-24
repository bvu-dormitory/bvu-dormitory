import 'package:bvu_dormitory/screens/admin/manage/students/widgets/student.stats.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/students/students.controller.dart';

class AdminStudentsScreen extends BaseScreen<AdminStudentsController> {
  AdminStudentsScreen({Key? key, required String previousPageTitle})
      : super(key: key, previousPageTitle: previousPageTitle);

  @override
  AdminStudentsController provideController(BuildContext context) {
    return AdminStudentsController(
      context: context,
      title: AppLocalizations.of(context)?.admin_manage_student ??
          "admin_manage_student",
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // CupertinoSearchTextField(
            //   placeholder:
            //       AppLocalizations.of(context)?.admin_manage_student_search,
            // ),
            // const SizedBox(height: 30),
            const AdminStudentsStats(),
            const SizedBox(height: 30),
            _menu(context),
          ],
        ),
      ),
    );
  }

  _menu(BuildContext context) {
    final controller = context.read<AdminStudentsController>();

    return AppMenuGroup(
      items: controller.menuItems,
    );
  }
}
