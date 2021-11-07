import 'dart:developer';

import 'package:bvu_dormitory/models/item.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/item.repository.dart';
import 'package:bvu_dormitory/repositories/room.repository.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'items.groups.detail.controller.dart';

class AdminItemsGroupsDetailScreen extends BaseScreen<AdminItemsGroupsDetailController> {
  AdminItemsGroupsDetailScreen({
    Key? key,
    required this.category,
    required this.group,
    String? previousPageTitle,
  }) : super(key: key, previousPageTitle: previousPageTitle);

  final ItemCategory category;
  final ItemGroup group;

  @override
  AdminItemsGroupsDetailController provideController(BuildContext context) {
    return AdminItemsGroupsDetailController(
      context: context,
      title: group.name,
      parentCategory: category,
      parentGroup: group,
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Icon(FluentIcons.channel_add_24_regular),
      onPressed: () {
        context.read<AdminItemsGroupsDetailController>().showItemEditBottomSheet();
      },
    );
  }

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _itemDetailList(),
      ),
    );
  }

  _itemDetailList() {
    final controller = context.read<AdminItemsGroupsDetailController>();

    return StreamBuilder<List<Item>>(
      stream: ItemRepository.syncItemDetailsInGroup(categoryId: category.id!, groupId: group.id!),
      builder: (context, snapshot) {
        // log(snapshot.toString());

        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
              return const Text('Error');
            }

            if (snapshot.hasData) {
              return _buildItemGroupsList(snapshot.data!);
            } else {
              return Text(controller.appLocalizations!.admin_manage_service_empty);
            }

          default:
            return const Center(child: CupertinoActivityIndicator(radius: 10));
        }
      },
    );
  }

  _buildItemGroupsList(List<Item> list) {
    final controller = context.read<AdminItemsGroupsDetailController>();

    return AppMenuGroup(
        items: list.map((item) {
      return AppMenuGroupItem(
        title: "${item.code} ",
        titleStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        hasTrailingArrow: false,
        subTitle: Container(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              _getRoomName(item.roomId),
              const SizedBox(width: 25),
              Text(item.purchaseDate),
              const SizedBox(width: 25),
              Text("${NumberFormat('#,###').format(int.parse(item.price))}đ"),
            ],
          ),
        ),
        onPressed: () => controller.onItemContextMenuOpen(item),
        // onLongPressed: () => controller.onItemContextMenuOpen(item),
      );
    }).toList());
  }

  _getRoomName(DocumentReference? roomRef) {
    if (roomRef == null) {
      return const Text('  ? ');
    }

    return FutureBuilder<Room>(
      future: RoomRepository.loadRoomFromRef(roomRef),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          case ConnectionState.active:
            if (snapshot.hasData) {
              return Text(snapshot.data!.name);
            }

            return const Text('  ? ');

          default:
            return const CupertinoActivityIndicator(radius: 5);
        }
      },
    );
  }
}
