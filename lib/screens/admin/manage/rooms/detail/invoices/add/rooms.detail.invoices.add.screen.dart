import 'dart:developer';

import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:bvu_dormitory/models/invoice.dart';
import 'package:bvu_dormitory/widgets/app.thousand_seperator.dart';
import 'package:bvu_dormitory/models/service.dart';
import 'package:bvu_dormitory/repositories/service.repository.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:tuple/tuple.dart';
import 'rooms.detail.invoices.add.controller.dart';

class AdminRoomsDetailInvoicesAddScreen extends BaseScreen<AdminRoomsDetailInvoicesAddController> {
  AdminRoomsDetailInvoicesAddScreen({
    Key? key,
    String? previousPageTitle,
    required this.building,
    required this.floor,
    required this.room,
    this.invoice,
  }) : super(key: key, previousPageTitle: previousPageTitle, haveNavigationBar: true);

  final Invoice? invoice;
  final Building building;
  final Floor floor;
  final Room room;

  @override
  AdminRoomsDetailInvoicesAddController provideController(BuildContext context) {
    return AdminRoomsDetailInvoicesAddController(
      context: context,
      title: invoice == null
          ? AppLocalizations.of(context)!.admin_manage_invoice_add
          : AppLocalizations.of(context)!.admin_manage_invoice_view,
      building: building,
      floor: floor,
      room: room,
      invoice: invoice,
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
          child: const Icon(FluentIcons.print_24_regular),
          onPressed: () {},
        ),
        if (invoice != null) ...{
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(FluentIcons.delete_16_regular, color: Colors.red),
            onPressed: () {
              controller.deleteInvoice(invoice!);
            },
          ),
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
        child: Form(
          key: controller.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
          // const SizedBox(height: 30),
          // _invoiceButtons(),
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
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: GoogleFonts.montserrat().fontFamily,
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: TextFormField(
              onTap: invoice != null
                  ? null
                  : () {
                      showCupertinoModalBottomSheet(
                        context: context,
                        builder: (_) {
                          var pickedDate = controller.getDateFromDateString(controller.dateController.text);

                          return Container(
                            height: 300,
                            padding: const EdgeInsets.only(bottom: 20),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CupertinoButton(
                                        child: Text(AppLocalizations.of(context)!.app_dialog_action_ok),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          controller.onDatePickerChanged(pickedDate);
                                        }),
                                  ],
                                ),
                                Expanded(
                                  child: CupertinoDatePicker(
                                    initialDateTime: pickedDate,
                                    mode: CupertinoDatePickerMode.date,
                                    minimumYear: 2010,
                                    maximumYear: DateTime.now().year + 1,
                                    onDateTimeChanged: (value) {
                                      pickedDate = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
              controller: controller.dateController,
              readOnly: true,
              textAlign: TextAlign.right,
              maxLength: 10,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: GoogleFonts.montserrat().fontFamily,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppLocalizations.of(context)!.app_form_field_required;
                }
              },
              decoration: const InputDecoration(
                counterText: '',
                isCollapsed: true,
                // contentPadding: EdgeInsets.only(bottom: 10),
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
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: GoogleFonts.montserrat().fontFamily,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            readOnly: invoice != null,
            maxLines: 5,
            maxLength: 255,
            controller: controller.notesController,
            textAlign: TextAlign.left,
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: GoogleFonts.montserrat().fontFamily,
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
      _invoiceContinousService(Service service, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // old index
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.admin_manage_invoice_old_index,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
                Text(
                  service.oldIndex?.toString() ?? "0",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
              ],
            ),

            // new index
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.admin_manage_invoice_new_index,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
                const SizedBox(width: 30),
                invoice != null
                    ? Text(
                        NumberFormat('#,###').format(service.newIndex),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          // fontStyle: FontStyle.italic,
                          fontSize: 14,
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                        ),
                      )
                    : Expanded(
                        child: TextFormField(
                          controller: controller.serviceControllers[index].item3,
                          textAlign: TextAlign.right,
                          maxLength: 9,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            // fontStyle: FontStyle.italic,
                            fontSize: 14,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                          onChanged: (value) {
                            controller.notifyListeners();
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            // filled: true,
                            // fillColor: Colors.red,
                            counterText: '',
                            suffixStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              // fontStyle: FontStyle.italic,
                            ),
                            errorStyle: TextStyle(textBaseline: TextBaseline.ideographic),
                            isCollapsed: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent, width: 0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: -3),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        );
      }

      _invoiceServiceItem(Service service, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // service name - price/unit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  service.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
                Flexible(
                  child: Text(
                    "${NumberFormat('#,###').format(service.price)}đ/${service.unit}",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                  ),
                ),
              ],
            ),

            // continous services
            const SizedBox(height: 5),
            if (service.type == ServiceType.continous) ...{
              _invoiceContinousService(service, index),
              const SizedBox(height: 10),
            },

            // discount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.admin_manage_invoice_cost_discount,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
                const SizedBox(width: 30),
                invoice != null
                    ? Text(
                        service.discounts == null ? '' : NumberFormat('#,###').format(service.discounts) + ' đ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          // fontStyle: FontStyle.italic,
                          fontSize: 14,
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                        ),
                      )
                    : Expanded(
                        child: TextFormField(
                          controller: controller.serviceControllers[index].item2,
                          textAlign: TextAlign.right,
                          maxLength: 10,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            // fontStyle: FontStyle.italic,
                            fontSize: 14,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                          onChanged: (value) {
                            // this must be called to update the "subtotal Text; Total cost" below
                            controller.notifyListeners();
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            ThousandsSeparatorInputFormatter(),
                          ],
                          decoration: const InputDecoration(
                            counterText: '',
                            suffixText: 'đ',
                            suffixStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              // fontStyle: FontStyle.italic,
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
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
                const SizedBox(width: 30),
                Flexible(
                  child: Consumer<AdminRoomsDetailInvoicesAddController>(
                    builder: (_, controller, __) {
                      return Text(
                        controller.getServiceSubtotal(service, index),
                        style: TextStyle(
                          color: Colors.yellow.shade900,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          // fontStyle: FontStyle.italic,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // bottom margin
            const SizedBox(height: 30),
          ],
        );
      }

      if (invoice != null) {
        controller.serviceControllers = [];

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: invoice!.services.length,
          itemBuilder: (context, index) {
            final theService = invoice!.services[index];

            controller.serviceControllers.add(
              Tuple3(
                theService,
                TextEditingController(text: (theService.discounts ?? "").toString()),
                theService.type == ServiceType.seperated
                    ? null
                    : TextEditingController(text: theService.newIndex!.toString()),
              ),
            );

            return _invoiceServiceItem(theService, index);
          },
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
                controller.serviceControllers = [];

                // filtering services in the room (that enabled)
                final roomAvailableServices = snapshot.data!
                    .where(
                      (element) => (element.rooms ?? []).contains(room.reference),
                    )
                    .toList();

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: roomAvailableServices.length,
                  itemBuilder: (context, index) {
                    final theService = roomAvailableServices[index];

                    controller.serviceControllers.add(
                      Tuple3(
                        theService,
                        TextEditingController(),
                        theService.type == ServiceType.seperated ? null : TextEditingController(text: '10'),
                      ),
                    );

                    return _invoiceServiceItem(theService, index);
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
      color: AppColor.secondaryBackgroundColor(context.read<AppController>().appThemeMode),
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
              fontFamily: GoogleFonts.montserrat().fontFamily,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.admin_manage_room + ' ' + room.name,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
              fontWeight: FontWeight.w800,
              fontFamily: GoogleFonts.montserrat().fontFamily,
              shadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
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
              fontFamily: GoogleFonts.montserrat().fontFamily,
            ),
          ),

          /// total
          Flexible(
            child: invoice != null
                ? Text(
                    NumberFormat('#,###').format(invoice!.total) + ' đ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                  )
                : Consumer<AdminRoomsDetailInvoicesAddController>(
                    builder: (context, controller, child) => Text(
                      NumberFormat('#,###').format(controller.totalCost) + ' đ',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  _invoiceButtons() {
    final controller = context.read<AdminRoomsDetailInvoicesAddController>();
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
            onPressed: controller.submit,
          ),
        ),
      ],
    );
  }
}
