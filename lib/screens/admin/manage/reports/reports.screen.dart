import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:provider/src/provider.dart';
import 'reports.controller.dart';

class AdminReportsScreen extends BaseScreen<AdminReportsController> {
  AdminReportsScreen({Key? key, String? previousPageTitle})
      : super(key: key, previousPageTitle: previousPageTitle, haveNavigationBar: true);

  @override
  AdminReportsController provideController(BuildContext context) {
    return AdminReportsController(context: context, title: AppLocalizations.of(context)!.admin_manage_stat);
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
            // const AdminStudentsStats(),
            // const SizedBox(height: 30),
            _menu(context),
          ],
        ),
      ),
    );
  }

  _menu(BuildContext context) {
    final controller = context.read<AdminReportsController>();

    return Column(
      children: List.generate(controller.menuItems.length, (index) {
        final theMenu = controller.menuItems[index];
        return Container(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: theMenu,
        );
      }),
    );

    // ListView.builder(
    //   itemBuilder: (context, index) {
    //     final theMenu = controller.menuItems[index];
    //     return theMenu;
    //   },
    // );
  }
}
