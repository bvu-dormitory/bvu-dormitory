import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/src/provider.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/buildings/buildings.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/buildings/widgets/buildings.body.dart';

import './search/buildings.search.screen.dart';

class AdminBuildingsScreen extends BaseScreen<AdminBuildingsController> {
  AdminBuildingsScreen({Key? key, String? previousPageTitle})
      : super(key: key, previousPageTitle: previousPageTitle);

  @override
  AdminBuildingsController provideController(BuildContext context) {
    return AdminBuildingsController(
      context: context,
      title: AppLocalizations.of(context)?.admin_manage_buildings_title ??
          "admin_manage_buildings_title",
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 20,
      borderRadius: BorderRadius.circular(20),
      child: const Icon(FluentIcons.search_24_regular),
      onPressed: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => AdminBuildingsSearchScreen(
              previousPageTitle:
                  Provider.of<AdminBuildingsController>(context).title,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget body(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: AdminBuildingsBody(),
      ),
    );
  }
}
