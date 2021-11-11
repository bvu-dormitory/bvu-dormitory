import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';

import 'package:bvu_dormitory/screens/admin/manage/rooms/rooms.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/widgets/rooms.body.dart';
import 'package:provider/src/provider.dart';

class AdminRoomsScreen extends BaseScreen<AdminRoomsController> {
  AdminRoomsScreen({
    Key? key,
    required String previousPageTitle,
    required this.building,
    required this.floor,
    this.pickingRoom = false,
  }) : super(key: key, previousPageTitle: previousPageTitle);

  final bool pickingRoom;
  final Building building;
  final Floor floor;

  String getTitle(BuildContext context) {
    final buildingString = "${AppLocalizations.of(context)?.admin_manage_building} ${building.name}";
    final floorString = "${AppLocalizations.of(context)?.admin_manage_floor} ${floor.order}";

    return "$buildingString - $floorString";
  }

  @override
  AdminRoomsController provideController(BuildContext context) {
    return AdminRoomsController(
      context: context,
      title: getTitle(context),
      building: building,
      floor: floor,
      pickingRoom: pickingRoom,
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {
    // final controller = context.read<AdminRoomsController>();

    // return CupertinoButton(
    //   padding: EdgeInsets.zero,
    //   child: const Icon(FluentIcons.home_add_24_regular),
    //   onPressed: () => controller.onAddRoomButtonPressed(),
    // );
  }

  @override
  Widget body(BuildContext context) {
    return const SafeArea(
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: AdminRoomsBody(),
        ),
      ),
    );
  }
}
