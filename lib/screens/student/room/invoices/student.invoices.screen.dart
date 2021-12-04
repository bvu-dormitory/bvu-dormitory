import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/models/invoice.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/invoice.repository.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'detail/student.invoices.detail.screen.dart';
import 'student.invoices.controller.dart';

class StudentInvoicesScreen extends BaseScreen<StudentInvoicesController> {
  StudentInvoicesScreen({
    Key? key,
    String? previousPageTitle,
    required this.room,
  }) : super(key: key, previousPageTitle: "$previousPageTitle ${room.name}", haveNavigationBar: true);

  final Room room;

  @override
  StudentInvoicesController provideController(BuildContext context) {
    return StudentInvoicesController(
      context: context,
      title: AppLocalizations.of(context)!.admin_manage_invoice_list,
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
          child: _invoicesList(),
        ),
      ),
    );
  }

  _invoicesList() {
    final controller = context.read<StudentInvoicesController>();

    return StreamBuilder<List<Invoice>>(
      stream: InvoiceRepository.syncInvoicesInRoom(roomRef: room.reference!),
      builder: (context, snapshot) {
        // log(snapshot.toString());

        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              log(snapshot.error.toString());
              controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
              // return const Text('Error');
            }

            if (snapshot.hasData) {
              return _buildInvoicesList(snapshot.data!);
            } else {
              return Text(controller.appLocalizations!.admin_manage_service_empty);
            }

          default:
            return const Center(child: CupertinoActivityIndicator(radius: 10));
        }
      },
    );
  }

  _buildInvoicesList(List<Invoice> list) {
    final controller = context.read<StudentInvoicesController>();

    final groupedByYear = groupBy(list, (Object? key) {
      return (key as Invoice).year;
    });

    return Column(
      children: groupedByYear.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: AppMenuGroup(
            title: e.key.toString(),
            items: e.value.map((invoice) {
              return AppMenuGroupItem(
                title: AppLocalizations.of(context)!.admin_manage_invoice_month(invoice.month),
                titleStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                subTitle: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Text(NumberFormat('#,###').format(invoice.paid) + 'đ'),
                      const Text('/'),
                      Text(NumberFormat('#,###').format(invoice.total) + 'đ'),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => StudentInvoicesDetailScreen(
                      invoice: invoice,
                      previousPageTitle: controller.title,
                    ),
                  ));
                },
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
