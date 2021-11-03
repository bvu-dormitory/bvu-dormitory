import 'dart:developer';

import 'package:bvu_dormitory/models/item.dart';
import 'package:bvu_dormitory/repositories/item.repository.dart';
import 'package:bvu_dormitory/widgets/app.form.field.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/src/provider.dart';
import 'package:spannable_grid/spannable_grid.dart';
import 'items.controller.dart';

class AdminItemsScreen extends BaseScreen<AdminItemsController> {
  AdminItemsScreen({Key? key, String? previousPageTitle})
      : super(key: key, previousPageTitle: previousPageTitle, haveNavigationBar: true);

  @override
  AdminItemsController provideController(BuildContext context) {
    return AdminItemsController(context: context, title: AppLocalizations.of(context)!.admin_manage_item);
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Icon(FluentIcons.folder_add_24_regular),
      onPressed: () {
        context.read<AdminItemsController>().showCategoryAddingModal();
      },
    );
  }

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _itemCategiesList(),
      ),
    );
  }

  _itemCategiesList() {
    final controller = context.read<AdminItemsController>();

    return StreamBuilder<List<ItemCategory>>(
      stream: ItemRepository.syncCategories(),
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
              return _buildItemCategoriesList(snapshot.data!);
            } else {
              return Text(controller.appLocalizations!.admin_manage_service_empty);
            }

          default:
            return const Center(child: CupertinoActivityIndicator(radius: 10));
        }
      },
    );
  }

  _buildItemCategoriesList(List<ItemCategory> list) {
    final controller = context.read<AdminItemsController>();

    return AppMenuGroup(
        items: list.map((category) {
      return AppMenuGroupItem(
        title: category.name,
        titleStyle: const TextStyle(
          fontWeight: FontWeight.w400,
        ),
        onPressed: () {},
        onLongPressed: () => controller.onItemCategoryPressed(category),
      );
    }).toList());
  }
}
