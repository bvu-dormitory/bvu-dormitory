import 'dart:developer';

import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/room.repository.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/invoices/add/rooms.detail.invoices.add.screen.dart';
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
import 'package:tuple/tuple.dart';
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
        // child: _invoicesList(),
        child: Column(
          children: [
            _stats(),
          ],
        ),
      ),
    );
  }

  _stats() {
    final controller = context.read<AdminInvoicesController>();

    // Tuple<all revenue, remaining invoices, remaining cash>
    return FutureBuilder<Tuple3<int, List<Invoice>, int>>(
      future: InvoiceRepository.allRevenue(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log(snapshot.error.toString());
          controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
        }

        if (snapshot.hasData) {
          final theRevenue = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.secondaryBackgroundColor(context.read<AppController>().appThemeMode),
                  // color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 0.5,
                    color: AppColor.borderColor(context.read<AppController>().appThemeMode),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      NumberFormat('#,###').format(theRevenue.item1) + ' đ',
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.green,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      AppLocalizations.of(context)!.student_invoice_paid,
                      style: TextStyle(color: Colors.green.shade800),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Text(
                AppLocalizations.of(context)!.admin_reports_repairs_waiting,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              //
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.secondaryBackgroundColor(context.read<AppController>().appThemeMode),
                        // color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 0.5,
                          color: AppColor.borderColor(context.read<AppController>().appThemeMode),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            theRevenue.item2.length.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.amber.shade900,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context)!.admin_manage_room,
                            style: TextStyle(color: Colors.amber.shade800),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.secondaryBackgroundColor(context.read<AppController>().appThemeMode),
                        // color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 0.5,
                          color: AppColor.borderColor(context.read<AppController>().appThemeMode),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            NumberFormat('#,###').format(theRevenue.item3) + ' đ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.amber.shade900,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context)!.student_invoice_difference,
                            style: TextStyle(color: Colors.amber.shade800),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              _buildInvoicesList(theRevenue.item2),
            ],
          );
        }

        return const CupertinoActivityIndicator(radius: 10);
      },
    );
  }

  _buildInvoicesList(List<Invoice> list) {
    final controller = context.read<AdminInvoicesController>();

    final groupedByYear = groupBy(list, (Object? key) {
      return (key as Invoice).room;
    });

    return Column(
      children: groupedByYear.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: FutureBuilder<Room>(
            future: RoomRepository.loadRoomFromRef(e.key),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return AppMenuGroup(
                  title: AppLocalizations.of(context)!.admin_manage_room + " " + snapshot.data!.name.toString(),
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
                        controller.navigator.push(
                          CupertinoPageRoute(
                            builder: (context) => AdminRoomsDetailInvoicesAddScreen(
                              room: snapshot.data!,
                              invoice: invoice,
                              previousPageTitle: controller.title,
                            ),
                          ),
                        );
                      },
                      // onLongPressed: () => controller.onInvoiceItemContextMenuOpen(invoice),
                    );
                  }).toList(),
                );
              }

              return const CupertinoActivityIndicator(radius: 10);
            },
          ),
        );
      }).toList(),
    );
  }
}
