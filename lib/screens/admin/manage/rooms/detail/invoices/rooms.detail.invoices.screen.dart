import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/invoice.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/invoice.repository.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'add/rooms.detail.invoices.add.screen.dart';
import 'rooms.detail.invoices.controller.dart';

class AdminRoomsDetailInvoicesScreen extends BaseScreen<AdminRoomsDetailInvoicesController> {
  AdminRoomsDetailInvoicesScreen({
    Key? key,
    String? previousPageTitle,
    required this.building,
    required this.floor,
    required this.room,
  }) : super(key: key, previousPageTitle: previousPageTitle, haveNavigationBar: true);

  final Building building;
  final Floor floor;
  final Room room;

  @override
  AdminRoomsDetailInvoicesController provideController(BuildContext context) {
    return AdminRoomsDetailInvoicesController(
      context: context,
      title: AppLocalizations.of(context)!.admin_manage_invoice,
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Icon(FluentIcons.receipt_add_24_regular),
      onPressed: () {
        Navigator.of(context).push(CupertinoPageRoute(
          builder: (_) => AdminRoomsDetailInvoicesAddScreen(
            previousPageTitle: context.read<AdminRoomsDetailInvoicesController>().title,
            building: building,
            floor: floor,
            room: room,
          ),
        ));
      },
    );
  }

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
    final controller = context.read<AdminRoomsDetailInvoicesController>();

    return StreamBuilder<List<Invoice>>(
      stream: InvoiceRepository.syncInvoicesInRoom(buildingId: building.id!, floorId: floor.id!, roomId: room.id!),
      builder: (context, snapshot) {
        // log(snapshot.toString());

        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
              // return const Text('Error');
            }

            if (snapshot.hasData) {
              return _buildItemCategoriesList(snapshot.data!);
            } else {
              return Text(controller.appLocalizations!.admin_manage_service_empty);
            }

          default:
            return const Center(child: CupertinoActivityIndicator(radius: 10));
        }
      },
    );
  }

  _buildItemCategoriesList(List<Invoice> list) {
    final controller = context.read<AdminRoomsDetailInvoicesController>();

    final groupedByYear = groupBy(list, (Object? key) {
      return (key as Invoice).year;
    });

    return Column(
      children: groupedByYear.entries.map((e) {
        return AppMenuGroup(
          title: e.key.toString(),
          items: e.value
              .map(
                (invoice) => AppMenuGroupItem(
                  title: AppLocalizations.of(context)!.admin_manage_invoice_month(invoice.month),
                  titleStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  subTitle: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text(NumberFormat('#,###').format(invoice.cost) + 'đ'),
                      ],
                    ),
                  ),
                  onPressed: () => controller.onInvoiceItemPressed(invoice),
                  onLongPressed: () => controller.onInvoicdItemContextMenuOpen(invoice),
                ),
              )
              .toList(),
        );
      }).toList(),
    );
  }
}
