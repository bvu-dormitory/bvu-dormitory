import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/item.dart';
import 'package:bvu_dormitory/repositories/item.repository.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class AdminRoomsDetailItemsController extends BaseController {
  AdminRoomsDetailItemsController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  void onItemPressed(Item theItem) {
    showBottomSheetMenuModal(
      theItem.code,
      null,
      true,
      [
        AppModalBottomSheetMenuGroup(items: [
          AppModalBottomSheetItem(
            label: appLocalizations!.admin_manage_item_detail_detach,
            labelStyle: const TextStyle(color: Colors.red),
            icon: const Icon(FluentIcons.sign_out_24_regular, color: Colors.red),
            onPressed: () => _detachFromRoom(theItem),
          ),
        ]),
      ],
    );
  }

  _detachFromRoom(Item theItem) async {
    if (await hasConnectivity()) {
      showLoadingDialog();
      try {
        await ItemRepository.detachFromRoom(theItem);
        navigator.pop();
      } catch (e) {
        showSnackbar(e.toString(), const Duration(seconds: 5), () {});
      } finally {
        navigator.pop();
      }
    }
  }
}
