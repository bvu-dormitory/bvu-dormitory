import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/building.dart';

import 'rooms.detail.images.controller.dart';
import 'rooms.detail.images.body.dart';

class AdminRoomsDetailImagesScreen
    extends BaseScreen<AdminRoomsDetailImagesController> {
  //
  AdminRoomsDetailImagesScreen({
    Key? key,
    required String previousPageTitle,
    required this.building,
    required this.floor,
    required this.room,
  }) : super(key: key, previousPageTitle: previousPageTitle);

  final Building building;
  final Floor floor;
  final Room room;

  @override
  AdminRoomsDetailImagesController provideController(BuildContext context) {
    return AdminRoomsDetailImagesController(
      context: context,
      title: AppLocalizations.of(context)?.admin_manage_rooms_detail_images ??
          "admin_manage_rooms_detail_images",
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
        child: AdminRoomsDetailImagesBody(),
      ),
    );
  }
}
