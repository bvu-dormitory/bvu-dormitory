import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/buildings/buildings.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/buildings/widgets/buildings.body.dart';

class AdminBuildingsScreen extends BaseScreen<AdminBuildingsController> {
  AdminBuildingsScreen({Key? key, String? previousPageTitle})
      : super(key: key, previousPageTitle: previousPageTitle);

  @override
  Widget body(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: AdminBuildingsBody(),
      ),
    );
  }

  @override
  AdminBuildingsController provideController(BuildContext context) {
    return AdminBuildingsController(
      context: context,
      title: provideTitle(context),
    );
  }

  @override
  String provideTitle(BuildContext context) {
    return "";
  }

  @override
  CupertinoNavigationBar? navigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      transitionBetweenRoutes: true,
      previousPageTitle: AppLocalizations.of(context)?.admin_manage_title,
      middle: Text(
        AppLocalizations.of(context)?.admin_manage_buildings_title ??
            "admin_manage_buildings_title",
      ),
    );
  }
}
