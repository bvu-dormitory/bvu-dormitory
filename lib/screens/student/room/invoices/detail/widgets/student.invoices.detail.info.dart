import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/models/invoice.dart';
import 'package:flutter/material.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/models/service.dart';
import 'package:tuple/tuple.dart';

import '../student.invoices.detail.controller.dart';

class StudentInvoicesDetailInfo extends StatelessWidget {
  const StudentInvoicesDetailInfo({
    Key? key,
    required this.invoice,
  }) : super(key: key);

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return _invoicePanel(context);
  }

  _invoicePanel(BuildContext context) {
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
                  _invoiceHeader(context, radius),

                  // invoide body
                  Expanded(
                    child: Scrollbar(
                      thickness: 1,
                      child: SingleChildScrollView(
                        child: _invoiceBody(context),
                        physics: const ClampingScrollPhysics(),
                      ),
                    ),
                  ),

                  // invoice footer
                  _invoiceFooter(context, radius),
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

  _invoiceBody(BuildContext context) {
    final controller = context.read<StudentInvoicesDetailController>();

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
            readOnly: true,
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
                Text(
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
                Text(
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
                Text(
                  controller.getServiceSubtotal(service, index),
                  style: TextStyle(
                    color: Colors.yellow.shade900,
                    fontWeight: FontWeight.w600,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    // fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),

            // bottom margin
            const SizedBox(height: 30),
          ],
        );
      }

      controller.serviceControllers = [];
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: invoice.services.length,
        itemBuilder: (context, index) {
          final theService = invoice.services[index];

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

    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(20),
      color: AppColor.navigationBackgroundColor(context.read<AppController>().appThemeMode),
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

  _invoiceHeader(BuildContext context, double radius) {
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
        ],
      ),
    );
  }

  _invoiceFooter(BuildContext context, double radius) {
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
              child: Text(
            NumberFormat('#,###').format(invoice.total) + ' đ',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
              fontWeight: FontWeight.w800,
              fontFamily: GoogleFonts.montserrat().fontFamily,
            ),
          )),
        ],
      ),
    );
  }
}
