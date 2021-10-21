import 'dart:developer';

import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'rooms.detail.images.controller.dart';

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
  String provideTitle(BuildContext context) {
    return "";
  }

  @override
  AdminRoomsDetailImagesController provideController(BuildContext context) {
    return AdminRoomsDetailImagesController(
      context: context,
      title: provideTitle(context),
      building: building,
      floor: floor,
      room: room,
    );
  }

  @override
  CupertinoNavigationBar? navigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      previousPageTitle: previousPageTitle,
      middle: Text(
        AppLocalizations.of(context)?.admin_manage_rooms_detail_images ??
            "admin_manage_rooms_detail_images",
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Consumer<AdminRoomsDetailImagesController>(
          builder: (context, value, child) {
            print(value);
            return Text(
              AppLocalizations.of(context)?.admin_manage_repair ??
                  "admin_manage_repair",
            );
          },
        ),
      ),
    );
  }
}
