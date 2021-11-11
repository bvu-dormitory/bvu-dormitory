import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spannable_grid/spannable_grid.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'rooms.detail.invoices.add.controller.dart';

class AdminRoomsDetailInvoicesAddScreen extends BaseScreen<AdminRoomsDetailInvoicesAddController> {
  AdminRoomsDetailInvoicesAddScreen({
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
  AdminRoomsDetailInvoicesAddController provideController(BuildContext context) {
    return AdminRoomsDetailInvoicesAddController(
        context: context, title: AppLocalizations.of(context)!.admin_manage_invoice_add);
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    final controller = context.read<AdminRoomsDetailInvoicesAddController>();

    return SafeArea(
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SpannableGrid(
            editingOnLongPress: false,
            columns: 1,
            rows: 10,
            cells: [],
          ),
        ),
      ),
    );
  }
}
