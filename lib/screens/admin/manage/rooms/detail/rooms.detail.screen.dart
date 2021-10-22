import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/rooms.detail.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/widgets/rooms.detail.body.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/base/base.screen.dart';

class AdminRoomsDetailScreen extends BaseScreen<AdminRoomsDetailController> {
  AdminRoomsDetailScreen(
      {Key? key,
      required String previousPageTitle,
      required this.building,
      required this.floor,
      required this.room})
      : super(key: key, previousPageTitle: previousPageTitle);

  final Building building;
  final Floor floor;
  final Room room;

  @override
  AdminRoomsDetailController provideController(BuildContext context) {
    final roomTitle =
        AppLocalizations.of(context)?.admin_manage_room ?? "admin_manage_room";

    return AdminRoomsDetailController(
      context: context,
      title: "$roomTitle ${room.name}",
      building: building,
      floor: floor,
      room: room,
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: AdminRoomsDetailBody(),
      ),
    );
  }
}
