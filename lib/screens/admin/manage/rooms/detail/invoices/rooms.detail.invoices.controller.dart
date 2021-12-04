import 'dart:developer';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/invoice.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/invoice.repository.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/invoices/add/rooms.detail.invoices.add.screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminRoomsDetailInvoicesController extends BaseController {
  AdminRoomsDetailInvoicesController({
    required BuildContext context,
    required String title,
    required this.building,
    required this.floor,
    required this.room,
  }) : super(context: context, title: title);

  final Building building;
  final Floor floor;
  final Room room;

  onInvoiceItemPressed(Invoice invoice) {
    navigator.push(
      CupertinoPageRoute(
        builder: (context) => AdminRoomsDetailInvoicesAddScreen(
          previousPageTitle: appLocalizations!.admin_manage_invoice,
          room: room,
          invoice: invoice,
        ),
      ),
    );
  }

  onInvoiceItemContextMenuOpen(Invoice invoice) {
    showBottomSheetMenuModal(
      appLocalizations!.admin_manage_invoice_title(room.name, invoice.month, invoice.year),
      null,
      true,
      [
        AppModalBottomSheetMenuGroup(items: [
          AppModalBottomSheetItem(
            label: appLocalizations!.app_action_delete,
            labelStyle: const TextStyle(color: Colors.red),
            icon: const Icon(FluentIcons.delete_24_regular, color: Colors.red),
            onPressed: () => _deleteInvoice(invoice),
          ),
        ]),
      ],
    );
  }

  _deleteInvoice(Invoice invoice) async {
    if (await hasConnectivity()) {
      try {
        await InvoiceRepository.deleteInvoice(invoice);
      } catch (e) {
        showSnackbar(e.toString(), const Duration(seconds: 5), () {});
      } finally {
        navigator.pop();
      }
    }
  }
}
