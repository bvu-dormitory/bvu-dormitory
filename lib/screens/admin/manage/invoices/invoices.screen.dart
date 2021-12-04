import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:bvu_dormitory/models/invoice.dart';
import 'package:bvu_dormitory/repositories/invoice.repository.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/buildings/buildings.screen.dart';
import 'invoices.controller.dart';

class AdminInvoicesScreen extends BaseScreen<AdminInvoicesController> {
  AdminInvoicesScreen({Key? key, String? previousPageTitle})
      : super(
          key: key,
          previousPageTitle: previousPageTitle,
          haveNavigationBar: true,
        );

  @override
  AdminInvoicesController provideController(BuildContext context) {
    return AdminInvoicesController(context: context, title: AppLocalizations.of(context)!.admin_manage_invoice);
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Icon(FluentIcons.note_add_24_regular),
      onPressed: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => AdminBuildingsScreen(previousPageTitle: context.read<AdminInvoicesController>().title),
          ),
        );
      },
    );
  }

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _invoicesList(),
      ),
    );
  }

  _invoicesList() {
    final controller = context.read<AdminInvoicesController>();

    return StreamBuilder<List<Invoice>>(
      stream: InvoiceRepository.syncInvoices(),
      builder: (context, snapshot) {
        log(snapshot.toString());

        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
              log(snapshot.error.toString());
              return const Text('Error');
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
    final controller = context.read<AdminInvoicesController>();

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
                // onPressed: () => controller.onInvoiceItemPressed(invoice),
                // onLongPressed: () => controller.onInvoiceItemContextMenuOpen(invoice),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
