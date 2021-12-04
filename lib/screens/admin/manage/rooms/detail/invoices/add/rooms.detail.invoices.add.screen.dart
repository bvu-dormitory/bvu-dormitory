import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/models/invoice.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'rooms.detail.invoices.add.controller.dart';

class AdminRoomsDetailInvoicesAddScreen extends BaseScreen<AdminRoomsDetailInvoicesAddController> {
  AdminRoomsDetailInvoicesAddScreen({
    Key? key,
    String? previousPageTitle,
    required this.room,
    this.invoice,
  }) : super(key: key, previousPageTitle: previousPageTitle, haveNavigationBar: true);

  final Invoice? invoice;
  final Room room;

  @override
  AdminRoomsDetailInvoicesAddController provideController(BuildContext context) {
    return AdminRoomsDetailInvoicesAddController(
      context: context,
      title: invoice == null
          ? AppLocalizations.of(context)!.admin_manage_invoice_add
          : AppLocalizations.of(context)!.admin_manage_invoice_view,
      room: room,
      invoice: invoice,
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {
    final controller = context.read<AdminRoomsDetailInvoicesAddController>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.printer, size: 20),
          onPressed: () {
            controller.print();
          },
        ),
        if (invoice != null) ...{
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(FluentIcons.delete_16_regular, color: Colors.red),
            onPressed: () {
              controller.deleteInvoice(invoice!);
            },
          ),
        } else ...{
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(FluentIcons.checkmark_24_regular),
            onPressed: controller.submit,
          ),
        }
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    // final controller = context.read<AdminRoomsDetailInvoicesAddController>();

    return SafeArea(
      // bottom: false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Expanded(
              child: Consumer<AdminRoomsDetailInvoicesAddController>(
                builder: (context, controller, child) => controller.currentSegmentWidget,
              ),
            ),
            if (invoice != null) ...{
              const SizedBox(height: 10),
              _slider(),
            },
          ],
        ),
      ),
    );
  }

  _slider() {
    return CupertinoSlidingSegmentedControl(
      children: context.read<AdminRoomsDetailInvoicesAddController>().segmentKeys,
      groupValue: context.watch<AdminRoomsDetailInvoicesAddController>().currentSegmentKey,
      onValueChanged: (value) {
        context.read<AdminRoomsDetailInvoicesAddController>().updateCurrentSegment(value);
      },
    );
  }
}
