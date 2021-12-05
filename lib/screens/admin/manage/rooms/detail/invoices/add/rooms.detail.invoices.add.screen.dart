import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/invoices/add/widgets/invoice.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/invoices/add/widgets/payments.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/models/invoice.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'rooms.detail.invoices.add.controller.dart';

class AdminRoomsDetailInvoicesAddScreen extends BaseScreen<AdminRoomsDetailInvoicesAddController> {
  AdminRoomsDetailInvoicesAddScreen({
    Key? key,
    String? previousPageTitle,
    required this.room,
    this.invoice,
    this.student,
  }) : super(key: key, previousPageTitle: previousPageTitle, haveNavigationBar: true);

  final Invoice? invoice;
  final Room room;
  final Student? student;

  @override
  AdminRoomsDetailInvoicesAddController provideController(BuildContext context) {
    return AdminRoomsDetailInvoicesAddController(
      context: context,
      title: invoice == null
          ? AppLocalizations.of(context)!.admin_manage_invoice_add
          : AppLocalizations.of(context)!.admin_manage_invoice_view,
      room: room,
      invoice: invoice,
      student: student,
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
          if (student == null) ...{
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(FluentIcons.delete_16_regular, color: Colors.red),
              onPressed: () {
                controller.deleteInvoice(invoice!);
              },
            ),
          }
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
    final controller = context.read<AdminRoomsDetailInvoicesAddController>();

    return SafeArea(
      // bottom: false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              Expanded(
                child: FlipCard(
                  controller: controller.flipController,
                  fill: Fill.fillBack, // Fill the back side of the card to make in the same size as the front.
                  direction: FlipDirection.HORIZONTAL, // default
                  front: AdminRoomsDetailInvoicesAddInvoice(invoice: invoice),
                  back: AdminRoomsDetailInvoicesAddPayments(),
                  flipOnTouch: false,
                  // onFlipDone: (value) {
                  //   controller.updateCurrentSegment((controller.currentSegmentKey - 1).abs());
                  // },
                ),
              ),
              if (invoice != null) ...{
                const SizedBox(height: 10),
                _slider(),
              },
            ],
          ),
        ),
      ),
    );
  }

  _slider() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CupertinoSlidingSegmentedControl(
        children: context.read<AdminRoomsDetailInvoicesAddController>().segmentKeys,
        groupValue: context.watch<AdminRoomsDetailInvoicesAddController>().currentSegmentKey,
        onValueChanged: (value) {
          context.read<AdminRoomsDetailInvoicesAddController>().updateCurrentSegment(value);
        },
      ),
    );
  }
}
