import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';

import 'package:bvu_dormitory/screens/admin/manage/rooms/rooms.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/widgets/rooms.body.dart';

class AdminRoomsScreen extends BaseScreen<AdminRoomsController> {
  AdminRoomsScreen({
    Key? key,
    required String previousPageTitle,
    required this.building,
    required this.floor,
  }) : super(key: key, previousPageTitle: previousPageTitle);

  final Building building;
  final Floor floor;

  @override
  String provideTitle(BuildContext context) {
    return "";
  }

  @override
  AdminRoomsController provideController(BuildContext context) {
    return AdminRoomsController(
      context: context,
      title: provideTitle(context),
      building: building,
      floor: floor,
    );
  }

  @override
  CupertinoNavigationBar? navigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      transitionBetweenRoutes: true,
      previousPageTitle: previousPageTitle,
      middle: Text(
        AppLocalizations.of(context)?.admin_manage_rooms_title ??
            "admin_manage_floors_title",
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: AdminRoomsBody(),
      ),
    );
  }
}
