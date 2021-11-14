import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:bvu_dormitory/models/service.dart';
import 'package:bvu_dormitory/repositories/service.repository.dart';
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
      // bottom: false,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode().requestFocus(FocusNode());
        },
        child: Form(
          key: controller.formKey,
          child: _invoicePanel(),
        ),
      ),
    );
  }

  _invoicePanel() {
    const radius = 10.0;

    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
      child: Column(
        children: [
          Expanded(
            child: DottedBorder(
              color: Colors.blue,
              strokeWidth: 1,
              strokeCap: StrokeCap.square,
              dashPattern: const [10],
              radius: const Radius.circular(radius),
              borderType: BorderType.RRect,
              child: Column(
                children: [
                  // invoice header
                  _invoiceHeader(radius),

                  // invoide body
                  Expanded(
                    child: Scrollbar(
                      thickness: 1,
                      child: SingleChildScrollView(
                        child: _invoiceBody(),
                      ),
                    ),
                  ),

                  // invoice footer
                  _invoiceFooter(radius),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          _invoiceButtons(),
        ],
      ),
    );
  }

  _invoiceBody() {
    final controller = context.read<AdminRoomsDetailInvoicesAddController>();

    _invoiceDateSection() {
      return Row(
        children: [
          Text(
            AppLocalizations.of(context)!.admin_manage_invoice_time,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: TextFormField(
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 300,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        mode: CupertinoDatePickerMode.date,
                        minimumYear: 2010,
                        maximumYear: DateTime.now().year,
                        onDateTimeChanged: controller.onDatePickerChanged,
                      ),
                    );
                  },
                );
                // DatePicker.showDatePicker(context, maxDateTime: DateTime.now(), dateFormat: 'MMMM-yyyy');
              },
              controller: controller.dateController,
              readOnly: true,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.only(bottom: 10),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
        ],
      );
    }

    _invoiceNotesSection() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.admin_manage_invoice_notes,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          TextFormField(
            maxLines: 5,
            controller: controller.notesController,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              // isCollapsed: true,
              contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 0, bottom: 10),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
            ),
          ),
        ],
      );
    }

    _invoiceServicesCostSection() {
      _invoiceContinousService(Service service) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // old index
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.admin_manage_invoice_old_index,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  '0',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),

            // new index
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.admin_manage_invoice_new_index,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: TextFormField(
                    // controller: disCountController,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                    decoration: const InputDecoration(
                      suffixStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                      ),
                      isCollapsed: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }

      _invoiceServiceItem(Service service) {
        final disCountController = TextEditingController();
        log('rebuilding service field...');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // service name - price/unit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  service.name,
                  style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black.withOpacity(0.6)),
                ),
                Text(
                  "${service.price}/${service.unit}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 5),
            if (service.type == ServiceType.continous) ...{
              _invoiceContinousService(service),
              const SizedBox(height: 10),
            },

            // discount
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.admin_manage_invoice_cost_discount,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: TextFormField(
                    controller: disCountController,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                    decoration: const InputDecoration(
                      suffixText: 'đ',
                      suffixStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                      ),
                      isCollapsed: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
              ],
            ),

            // subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.admin_manage_invoice_cost_subtotal,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 30),
                Text(
                  "${service.price - (int.tryParse(disCountController.text) ?? 0)} đ",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),

            // bottom margin
            const SizedBox(height: 30),
          ],
        );
      }

      return StreamBuilder<List<Service>>(
        stream: ServiceRepository.syncServices(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                context
                    .read<AdminRoomsDetailInvoicesAddController>()
                    .showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
              }

              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final theService = snapshot.data![index];
                    return _invoiceServiceItem(theService);
                  },
                );
              } else {
                return SafeArea(
                  child: Text(AppLocalizations.of(context)!.admin_manage_rooms_detail_students_empty),
                );
              }

            default:
              return const SafeArea(
                child: Center(
                  child: CupertinoActivityIndicator(
                    radius: 10,
                  ),
                ),
              );
          }
        },
      );
    }

    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: _invoiceDateSection(),
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Colors.grey.withOpacity(0.35),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          _invoiceServicesCostSection(),
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          _invoiceNotesSection(),
        ],
      ),
    );
  }

  _invoiceHeader(double radius) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue,
            Colors.lightBlue.shade200,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.admin_manage_invoice,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.admin_manage_room + ' ' + room.name,
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 15, fontWeight: FontWeight.w800, shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(3, 3),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  _invoiceFooter(double radius) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(radius)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue,
            Colors.blue,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.admin_manage_invoice_cost_total,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          Flexible(
            child: Consumer<AdminRoomsDetailInvoicesAddController>(
              builder: (context, controller, child) => Text(
                NumberFormat('#,###').format(controller.totalCost) + ' đ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _invoiceButtons() {
    const radius = 50.0;

    return Row(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(radius),
          child: DottedBorder(
            radius: const Radius.circular(radius),
            borderType: BorderType.RRect,
            color: Colors.blue,
            dashPattern: const [0.1],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(radius),
              //   border: Border.all(
              //     color: Colors.blue,
              //   ),
              // ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.share, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    AppLocalizations.of(context)!.admin_manage_invoice_export,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 20),
        Flexible(
          fit: FlexFit.tight,
          child: CupertinoButton(
            color: Colors.blue.shade500,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            borderRadius: BorderRadius.circular(radius),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.arrow_right, size: 20),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.admin_manage_invoice_send,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
