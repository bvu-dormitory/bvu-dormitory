import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/rooms.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/widgets/rooms.body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/app/constants/app.colors.dart';

class AdminRoomsScreen extends StatelessWidget {
  const AdminRoomsScreen(
      {Key? key, required this.building, required this.floor})
      : super(key: key);

  final Building building;
  final Floor floor;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          AdminRoomsController(context: _, building: building, floor: floor),
      child: CupertinoPageScaffold(
        navigationBar: _navBar(context),
        child: Scaffold(
          backgroundColor: AppColor.backgroundColor,
          body: const SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
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
      previousPageTitle: _previousPageTitle(context),
      middle: Text(AppLocalizations.of(context)?.admin_manage_rooms_title ??
          "admin_manage_floors_title"),
      // trailing: CupertinoButton(
      //     padding: EdgeInsets.zero,
      //     child: const Icon(CupertinoIcons.question_circle),
      //     onPressed: () {
      //       AppDialog.showInfoDialog(
      //           context: context,
      //           content: Text(
      //               AppLocalizations.of(context)?.admin_manage_floors_guide ??
      //                   "admin_manage_floors_guide"));
      //     }),
    );
  }

  String _previousPageTitle(BuildContext context) {
    final buildingTitle =
        "${AppLocalizations.of(context)?.admin_manage_building} ${building.name}";
    return "$buildingTitle - #${floor.order}";
  }
}
