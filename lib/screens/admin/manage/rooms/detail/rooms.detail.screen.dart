import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/rooms.detail.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';

class AdminRoomsDetailScreen extends BaseScreen<AdminRoomsDetailController> {
  AdminRoomsDetailScreen(
      {Key? key, required String previousPageTitle, required this.building, required this.floor, required this.room})
      : super(key: key, previousPageTitle: previousPageTitle);

  final Building building;
  final Floor floor;
  final Room room;

  @override
  AdminRoomsDetailController provideController(BuildContext context) {
    final roomTitle = AppLocalizations.of(context)?.admin_manage_room ?? "admin_manage_room";

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
    return SafeArea(
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: _body(),
        ),
      ),
    );
  }

  _body() {
    final controller = context.watch<AdminRoomsDetailController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        AppMenuGroup(
          title: controller.appLocalizations?.admin_manage_rooms_detail_info ?? "admin_manage_rooms_detail_info",
          items: controller.infoMenuItems,
        ),
        const SizedBox(height: 30),
        AppMenuGroup(
          title: controller.appLocalizations?.admin_manage_contact ?? "admin_manage_contact",
          items: controller.messageMenuItems,
        ),
        const SizedBox(height: 30),
        AppMenuGroup(
          title: controller.appLocalizations?.admin_manage_invoice ?? "admin_manage_invoice",
          items: controller.invoiceMenuItems,
        ),
        const SizedBox(height: 30),
        AppMenuGroup(
          title: controller.appLocalizations?.admin_manage_repair ?? "admin_manage_repair",
          items: controller.repairMenuItems,
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
