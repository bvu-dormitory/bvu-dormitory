import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:carousel_slider/carousel_controller.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/building.repository.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/images/rooms.detail.images.screen.dart';

class AdminRoomMenuItem {
  String title;
  IconData icon;
  Function? onPressed;

  AdminRoomMenuItem({required this.title, required this.icon, this.onPressed});
}

class AdminRoomsDetailController extends BaseController {
  BuildingRepository get _buildingRepository => BuildingRepository();

  Building building;
  Floor floor;
  Room room;

  AdminRoomsDetailController({
    required BuildContext context,
    required String title,
    required this.building,
    required this.floor,
    required this.room,
  }) : super(context: context, title: title);

  Stream<List<Room>> syncRooms() {
    return _buildingRepository.syncAllRooms(building.id!, floor.id!);
  }

  /// Info menu
  List<AdminRoomMenuItem> get infoMenuItems => [
        AdminRoomMenuItem(
            title: appLocalizations?.admin_manage_rooms_detail_images ??
                "admin_manage_rooms_detail_images",
            icon: CupertinoIcons.photo,
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => AdminRoomsDetailImagesScreen(
                    building: building,
                    floor: floor,
                    room: room,
                    previousPageTitle: title,
                  ),
                ),
              );
            }),
        AdminRoomMenuItem(
          title:
              appLocalizations?.admin_manage_service ?? "admin_manage_service",
          icon: CupertinoIcons.drop,
        ),
        AdminRoomMenuItem(
          title: appLocalizations?.admin_manage_item ?? "admin_manage_item",
          icon: CupertinoIcons.lightbulb,
        ),
        AdminRoomMenuItem(
          title:
              appLocalizations?.admin_manage_student ?? "admin_manage_student",
          icon: CupertinoIcons.person_2,
        ),
      ];

  /// Message menu
  List<AdminRoomMenuItem> get messageMenuItems => [
        AdminRoomMenuItem(
          title: appLocalizations?.admin_manage_rooms_detail_contact_chat ??
              "admin_manage_rooms_detail_contact_chat",
          icon: CupertinoIcons.bubble_left_bubble_right,
        ),
        AdminRoomMenuItem(
          title: appLocalizations?.admin_manage_rooms_detail_contact_phone ??
              "admin_manage_rooms_detail_contact_phone",
          icon: CupertinoIcons.phone,
          onPressed: () {
            showCupertinoModalBottomSheet(
              context: context,
              builder: (context) => Container(
                height: 300,
              ),
            );
          },
        ),
      ];

  /// Invoice menu
  List<AdminRoomMenuItem> get invoiceMenuItems => [
        AdminRoomMenuItem(
          title: appLocalizations?.admin_manage_rooms_detail_invoice_add ??
              "admin_manage_rooms_detail_invoice_add",
          icon: CupertinoIcons.add,
        ),
        AdminRoomMenuItem(
          title: appLocalizations?.admin_manage_rooms_detail_invoice_list ??
              "admin_manage_rooms_detail_invoice_list",
          icon: CupertinoIcons.square_stack_3d_up,
        ),
      ];

  /// Repair menu
  List<AdminRoomMenuItem> get repairMenuItems => [
        AdminRoomMenuItem(
          title: appLocalizations?.admin_manage_rooms_detail_repair_list ??
              "admin_manage_rooms_detail_repair_list",
          icon: CupertinoIcons.question,
        ),
        AdminRoomMenuItem(
          title: appLocalizations?.admin_manage_rooms_detail_repair_history ??
              "admin_manage_rooms_detail_repair_history",
          icon: CupertinoIcons.checkmark_alt,
        ),
      ];
}
