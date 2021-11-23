import 'dart:developer';

import 'package:bvu_dormitory/models/item.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/item.repository.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:collection/collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'student.items.controller.dart';

class StudentItemsScreen extends BaseScreen<StudentItemsController> {
  StudentItemsScreen({
    Key? key,
    String? previousPageTitle,
    required this.room,
  }) : super(key: key, previousPageTitle: "$previousPageTitle ${room.name}", haveNavigationBar: true);

  final Room room;

  @override
  StudentItemsController provideController(BuildContext context) {
    return StudentItemsController(
      context: context,
      title: AppLocalizations.of(context)!.admin_manage_item,
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: _itemsList(),
        ),
      ),
    );
  }

  _itemsList() {
    final controller = context.read<StudentItemsController>();

    return StreamBuilder<List<Item>>(
      stream: ItemRepository.syncItemsInRoom(roomRef: room.reference!),
      builder: (context, snapshot) {
        // log(snapshot.toString());

        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              log(snapshot.error.toString());
              controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
              return const Text('Error');
            }

            if (snapshot.hasData) {
              return _buildItemsList(snapshot.data!);
            } else {
              return Text(controller.appLocalizations!.admin_manage_service_empty);
            }

          default:
            return const Center(child: CupertinoActivityIndicator(radius: 10));
        }
      },
    );
  }

  _buildItemsList(List<Item> list) {
    final controller = context.read<StudentItemsController>();

    final groupedItems = groupBy(list, (Object? o) {
      return (o as Item).reference!.parent.parent!;
    });

    return Column(
      children: [
        Text(AppLocalizations.of(context)!.student_room_items_guide),
        const SizedBox(height: 50),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: groupedItems.length,
          itemBuilder: (context, index) {
            final items = groupedItems.values.toList()[index];
            final groupName = groupedItems.keys.toList()[index];

            return FutureBuilder<ItemGroup>(
              future: ItemRepository.syncParentGroupOfItem(itemRef: groupName),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      log(snapshot.error.toString());
                      controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
                    }

                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: AppMenuGroup(
                          title: snapshot.data!.name,
                          items: List.generate(items.length, (index) {
                            final theItem = items[index];

                            return AppMenuGroupItem(
                              title: theItem.code,
                              titleStyle: const TextStyle(fontWeight: FontWeight.w500),
                              hasTrailingArrow: false,
                              icon: const Icon(FluentIcons.number_symbol_16_regular),
                              subTitle: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  children: [
                                    Text(theItem.purchaseDate),
                                    const SizedBox(width: 20),
                                    Text("${NumberFormat('#,###').format(int.parse(theItem.price))}đ"),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }

                    return const Text('?');

                  default:
                    return const LinearProgressIndicator(minHeight: 1);
                }
              },
            );
          },
        ),
      ],
    );
  }
}
