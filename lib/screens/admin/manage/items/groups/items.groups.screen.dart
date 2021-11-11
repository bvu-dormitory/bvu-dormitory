import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/repositories/item.repository.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:bvu_dormitory/models/item.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'items.groups.controller.dart';

class AdminItemsGroupsScreen extends BaseScreen<AdminItemsGroupsController> {
  AdminItemsGroupsScreen({
    Key? key,
    String? previousPageTitle,
    required this.parentCategory,
  }) : super(key: key, previousPageTitle: previousPageTitle);

  final ItemCategory parentCategory;

  @override
  AdminItemsGroupsController provideController(BuildContext context) {
    return AdminItemsGroupsController(
      context: context,
      title: parentCategory.name,
      parentCategory: parentCategory,
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Icon(FluentIcons.folder_add_24_regular),
      onPressed: () {
        context.read<AdminItemsGroupsController>().showGroupEditBottomSheet();
      },
    );
  }

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: _itemGroupsList(),
        ),
      ),
    );
  }

  _itemGroupsList() {
    final controller = context.read<AdminItemsGroupsController>();

    return StreamBuilder<List<ItemGroup>>(
      stream: ItemRepository.syncItemGroupsInCategory(parentCategory.id!),
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

  _buildItemGroupsList(List<ItemGroup> list) {
    final controller = context.read<AdminItemsGroupsController>();

    return AppMenuGroup(
        items: list.map((group) {
      return AppMenuGroupItem(
        title: group.name,
        titleStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        subTitle: Container(
          padding: const EdgeInsets.only(top: 10),
          child: Text(group.providerName),
        ),
        onPressed: () => controller.onGroupItemPressed(group),
        onLongPressed: () => controller.onGroupItemContextMenuOpen(group),
      );
    }).toList());
  }
}
