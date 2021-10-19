import 'dart:developer';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/building.repository.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AdminRoomMenuItem {
  String title;
  Icon icon;
  Function? onPressed;

  AdminRoomMenuItem({required this.title, required this.icon, this.onPressed});
}

class AdminRoomsDetailController extends BaseController {
  BuildingRepository get _buildingRepository => BuildingRepository();

  Building building;
  Floor floor;
  Room room;

  CarouselController carouselController = CarouselController();

  AdminRoomsDetailController({
    required BuildContext context,
    required this.building,
    required this.floor,
    required this.room,
  }) : super(context: context);

  Stream<List<Room>> syncRooms() {
    return _buildingRepository.syncAllRooms(building.id!, floor.id!);
  }

  List<AdminRoomMenuItem> get messageMenuItems => [
        AdminRoomMenuItem(
          title: appLocalizations?.admin_manage_rooms_detail_contact_chat ??
              "admin_manage_rooms_detail_contact_chat",
          icon: const Icon(CupertinoIcons.bubble_left_bubble_right),
        ),
        AdminRoomMenuItem(
          title: appLocalizations?.admin_manage_rooms_detail_contact_phone ??
              "admin_manage_rooms_detail_contact_phone",
          icon: const Icon(CupertinoIcons.phone),
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

  List<AdminRoomMenuItem> get infoMenuItems => [
        AdminRoomMenuItem(
          title: appLocalizations?.admin_manage_rooms_detail_images ??
              "admin_manage_rooms_detail_images",
          icon: const Icon(CupertinoIcons.photo),
        ),
        AdminRoomMenuItem(
          title:
              appLocalizations?.admin_manage_service ?? "admin_manage_service",
          icon: const Icon(CupertinoIcons.drop),
        ),
        AdminRoomMenuItem(
          title: appLocalizations?.admin_manage_item ?? "admin_manage_item",
          icon: const Icon(CupertinoIcons.lightbulb),
        ),
        AdminRoomMenuItem(
          title:
              appLocalizations?.admin_manage_student ?? "admin_manage_student",
          icon: const Icon(CupertinoIcons.person_2),
        ),
      ];

  List<AdminRoomMenuItem> get invoiceMenuItems => [
        AdminRoomMenuItem(
          title: appLocalizations?.admin_manage_rooms_detail_invoice_add ??
              "admin_manage_rooms_detail_invoice_add",
          icon: const Icon(CupertinoIcons.add),
        ),
        AdminRoomMenuItem(
          title: appLocalizations?.admin_manage_rooms_detail_invoice_list ??
              "admin_manage_rooms_detail_invoice_list",
          icon: const Icon(CupertinoIcons.square_stack_3d_up),
        ),
      ];

  List<AdminRoomMenuItem> get repairMenuItems => [
        AdminRoomMenuItem(
          title: appLocalizations?.admin_manage_rooms_detail_repair_list ??
              "admin_manage_rooms_detail_repair_list",
          icon: const Icon(CupertinoIcons.question),
        ),
        AdminRoomMenuItem(
          title: appLocalizations?.admin_manage_rooms_detail_repair_history ??
              "admin_manage_rooms_detail_repair_history",
          icon: const Icon(CupertinoIcons.checkmark_alt),
        ),
      ];
}
