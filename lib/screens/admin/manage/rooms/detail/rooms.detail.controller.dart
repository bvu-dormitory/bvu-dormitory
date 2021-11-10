import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/items/rooms.detail.items.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/images/rooms.detail.images.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/students/rooms.detail.students.screen.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';

import 'services/rooms.detail.services.screen.dart';

class AdminRoomsDetailController extends BaseController {
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

  // Stream<List<Room>> syncRooms() {
  //   return _buildingRepository.syncAllRooms(building.id!, floor.id!);
  // }

  // Stream<Room> syncRoom() {
  //   return _buildingRepository.syncRoom(building.id!, floor.id!, room.id!);
  // }

  /// Info menu
  List<AppMenuGroupItem> get infoMenuItems => [
        AppMenuGroupItem(
          title: appLocalizations?.admin_manage_rooms_detail_images ?? "admin_manage_rooms_detail_images",
          icon: FluentIcons.image_multiple_24_filled,
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
          },
        ),
        AppMenuGroupItem(
          title: appLocalizations?.admin_manage_service ?? "admin_manage_service",
          icon: FluentIcons.wifi_1_24_filled,
          onPressed: () {
            navigator.push(
              CupertinoPageRoute(
                builder: (context) => AdminRoomsDetailServicesScreen(
                  building: building,
                  floor: floor,
                  room: room,
                  previousPageTitle: title,
                ),
              ),
            );
          },
        ),
        AppMenuGroupItem(
          title: appLocalizations?.admin_manage_item ?? "admin_manage_item",
          icon: FluentIcons.bed_24_filled,
          onPressed: () {
            navigator.push(
              CupertinoPageRoute(
                builder: (context) => AdminRoomsDetailItemsScreen(
                  building: building,
                  floor: floor,
                  room: room,
                  previousPageTitle: title,
                ),
              ),
            );
          },
        ),
        AppMenuGroupItem(
            title: appLocalizations?.admin_manage_student ?? "admin_manage_student",
            icon: FluentIcons.people_24_filled,
            onPressed: () {
              navigator.push(CupertinoPageRoute(
                builder: (context) => AdminRoomsDetailStudentsScreen(
                  previousPageTitle: title,
                  building: building,
                  floor: floor,
                  room: room,
                ),
              ));
            }),
      ];

  /// Message menu
  List<AppMenuGroupItem> get messageMenuItems => [
        AppMenuGroupItem(
          title: appLocalizations?.admin_manage_rooms_detail_contact_chat ?? "admin_manage_rooms_detail_contact_chat",
          icon: FluentIcons.chat_24_filled,
        ),
      ];

  /// Invoice menu
  List<AppMenuGroupItem> get invoiceMenuItems => [
        AppMenuGroupItem(
          title: appLocalizations?.admin_manage_rooms_detail_invoice_add ?? "admin_manage_rooms_detail_invoice_add",
          icon: FluentIcons.receipt_add_24_filled,
        ),
        AppMenuGroupItem(
          title: appLocalizations?.admin_manage_rooms_detail_invoice_list ?? "admin_manage_rooms_detail_invoice_list",
          icon: FluentIcons.checkbox_person_24_filled,
        ),
      ];

  /// Repair menu
  List<AppMenuGroupItem> get repairMenuItems => [
        AppMenuGroupItem(
          title: appLocalizations?.admin_manage_rooms_detail_repair_list ?? "admin_manage_rooms_detail_repair_list",
          icon: FluentIcons.chat_help_24_filled,
        ),
        AppMenuGroupItem(
          title:
              appLocalizations?.admin_manage_rooms_detail_repair_history ?? "admin_manage_rooms_detail_repair_history",
          icon: FluentIcons.checkbox_checked_24_filled,
        ),
      ];
}
