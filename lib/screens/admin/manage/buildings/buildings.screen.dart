import 'package:bvu_dormitory/app/app.dialog.dart';
import 'package:bvu_dormitory/screens/admin/manage/buildings/buildings.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/buildings/widgets/buildings.body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/app/constants/app.colors.dart';

class AdminBuildingsScreen extends StatelessWidget {
  AdminBuildingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminBuildingsController(context: _),
      child: CupertinoPageScaffold(
        navigationBar: _navBar(context),
        child: Scaffold(
          backgroundColor: AppColor.backgroundColor,
          body: const SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: AdminBuildingsBody(),
            ),
          ),
        ),
      ),
    );
  }

  _navBar(BuildContext context) {
    return CupertinoNavigationBar(
      transitionBetweenRoutes: true,
      previousPageTitle: AppLocalizations.of(context)?.admin_manage_title,
      middle: Text(AppLocalizations.of(context)?.admin_manage_buildings_title ??
          "admin_manage_buildings_title"),
      // trailing: CupertinoButton(
      //     padding: EdgeInsets.zero,
      //     child: const Icon(CupertinoIcons.question_circle),
      //     onPressed: () {
      //       AppDialog.showInfoDialog(
      //           context: context,
      //           content: Text(AppLocalizations.of(context)
      //                   ?.admin_manage_buildings_guide ??
      //               "admin_manage_buildings_guide"));
      //     }),
    );
  }
}
