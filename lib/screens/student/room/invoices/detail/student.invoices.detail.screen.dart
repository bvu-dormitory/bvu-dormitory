import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/models/invoice.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:provider/provider.dart';

import 'student.invoices.detail.controller.dart';
import 'widgets/student.invoices.detail.info.dart';
import 'widgets/student.invoices.detail.payments.dart';

class StudentInvoicesDetailScreen extends BaseScreen<StudentInvoicesDetailController> {
  StudentInvoicesDetailScreen({
    Key? key,
    String? previousPageTitle,
    required this.invoice,
    // required this.room,
  }) : super(key: key, previousPageTitle: previousPageTitle, haveNavigationBar: true);

  final Invoice invoice;
  // final Room room;

  @override
  StudentInvoicesDetailController provideController(BuildContext context) {
    return StudentInvoicesDetailController(
      context: context,
      title: AppLocalizations.of(context)!.admin_manage_invoice_view,
      invoice: invoice,
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      // bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tabbar(),
          Expanded(
            child: Consumer<StudentInvoicesDetailController>(
              builder: (context, controller, child) => controller.selectedSecmentWidget,
            ),
          ),
        ],
      ),
    );
  }

  _tabbar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      alignment: Alignment.center,
      child: Consumer<StudentInvoicesDetailController>(
        builder: (context, controller, child) {
          return CupertinoSlidingSegmentedControl(
            groupValue: controller.selectedSegment,
            children: {
              0: Text(AppLocalizations.of(context)!.admin_manage_invoice),
              1: Text(AppLocalizations.of(context)!.student_invoice_payments),
            },
            onValueChanged: (value) {
              context.read<StudentInvoicesDetailController>().selectedSegment = value as int;
            },
          );
        },
      ),
    );
  }
}
