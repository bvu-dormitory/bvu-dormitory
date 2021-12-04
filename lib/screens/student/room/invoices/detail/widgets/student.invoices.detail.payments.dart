import 'package:bvu_dormitory/screens/student/room/invoices/detail/student.invoices.detail.controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/models/invoice.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

class StudentInvoicesDetailPayments extends StatelessWidget {
  const StudentInvoicesDetailPayments({Key? key, required this.invoice}) : super(key: key);

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: _stats(context),
          ),
          const SizedBox(height: 30),
          _payButton(context),
        ],
      ),
    );
  }

  _stats(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${AppLocalizations.of(context)!.student_invoice_paid}: ${NumberFormat('#,###').format(invoice.paid)} đ",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "${AppLocalizations.of(context)!.student_invoice_difference}: ${NumberFormat('#,###').format(invoice.total - invoice.paid)} đ",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  _payButton(BuildContext context) {
    final controller = context.read<StudentInvoicesDetailController>();

    return Center(
      child: ElevatedButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FluentIcons.payment_24_filled, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              AppLocalizations.of(context)!.student_invoice_pay,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        onPressed: () {
          if (invoice.total == invoice.paid) {
            controller.showSnackbar(
              AppLocalizations.of(context)!.student_invoice_full,
              const Duration(seconds: 5),
              () {},
            );
          }
        },
      ),
    );
  }
}
