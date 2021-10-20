import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/widgets/rooms.detail.body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/rooms.detail.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';

class AdminRoomsDetailScreen extends StatelessWidget {
  const AdminRoomsDetailScreen(
      {Key? key,
      required this.building,
      required this.floor,
      required this.room})
      : super(key: key);

  final Building building;
  final Floor floor;
  final Room room;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminRoomsDetailController(
        context: _,
        building: building,
        floor: floor,
        room: room,
      ),
      child: CupertinoPageScaffold(
        navigationBar: _navBar(context),
        child: Scaffold(
          backgroundColor: AppColor.backgroundColor,
          body: const SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: AdminRoomsDetailBody(),
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
      middle: Text(_middleString(context)),
      // trailing: CupertinoButton(
      //   padding: EdgeInsets.zero,
      //   child: const Icon(CupertinoIcons.ellipsis_circle),
      //   onPressed: () {},
      // ),
    );
  }

  String _middleString(BuildContext context) {
    final roomTitle =
        AppLocalizations.of(context)?.admin_manage_room ?? "admin_manage_room";

    return "$roomTitle ${room.name}";
  }

  String _previousPageTitle(BuildContext context) {
    final buildingTitle =
        "${AppLocalizations.of(context)?.admin_manage_building} ${building.name}";
    return "$buildingTitle - #${floor.order}";
  }
}
