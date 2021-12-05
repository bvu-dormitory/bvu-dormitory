import 'package:bvu_dormitory/models/invoice.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import '../rooms.detail.invoices.add.controller.dart';

class AdminRoomsDetailInvoicesAddPayments extends StatefulWidget {
  AdminRoomsDetailInvoicesAddPayments({Key? key}) : super(key: key);

  @override
  _AdminRoomsDetailInvoicesAddPaymentsState createState() => _AdminRoomsDetailInvoicesAddPaymentsState();
}

class _AdminRoomsDetailInvoicesAddPaymentsState extends State<AdminRoomsDetailInvoicesAddPayments> {
  late AdminRoomsDetailInvoicesAddController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = context.read<AdminRoomsDetailInvoicesAddController>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.secondaryBackgroundColor(context.read<AppController>().appThemeMode),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _header(),
          Expanded(
            child: _paymentsList(),
          ),
          if (controller.student == null) ...{
            _addPaymentButton(),
          },
        ],
      ),
    );
  }

  _header() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: AppColor.borderColor(context.read<AppController>().appThemeMode)),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.admin_manage_invoice_cost_total),
              Text(NumberFormat('#,###').format(controller.totalCost) + ' đ'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.student_invoice_paid),
              Text(NumberFormat('#,###').format(controller.invoice!.paid) + ' đ'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.student_invoice_difference),
              Text(NumberFormat('#,###').format(controller.invoice!.paid - controller.invoice!.total) + ' đ'),
            ],
          ),
        ],
      ),
    );
  }

  _addPaymentButton() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Icon(FluentIcons.note_add_24_regular),
      onPressed: () {
        controller.showAddPaymentDialog();
      },
    );
  }

  _paymentsList() {
    return Scrollbar(
      child: ListView.builder(
        itemCount: controller.invoice!.payments.length,
        itemBuilder: (context, index) {
          final thePayment = controller.invoice!.payments[index];

          return ListTile(title: Text(thePayment.student?.fullName ?? "unknown"));
        },
      ),
    );
  }
}
