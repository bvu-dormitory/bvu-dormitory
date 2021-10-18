import 'package:bvu_dormitory/app/app.dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/screens/admin/manage/floors/rooms.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/floors/widgets/rooms.body.dart';

class AdminRoomsScreen extends StatelessWidget {
  AdminRoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminRoomsController(context: _),
      child: CupertinoPageScaffold(
        navigationBar: _navBar(context),
        child: Scaffold(
          backgroundColor: AppColor.backgroundColor,
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: AdminRoomsBody(),
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
      middle: Text(AppLocalizations.of(context)?.admin_manage_rooms_title ??
          "admin_manage_rooms_title"),
      trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.question_circle),
          onPressed: () {
            AppDialog.showInfoDialog(
                context: context,
                content: Text(
                    AppLocalizations.of(context)?.admin_manage_rooms_guide ??
                        "admin_manage_rooms_guide"));
          }),
    );
  }
}
