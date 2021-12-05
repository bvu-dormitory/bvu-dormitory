import 'dart:developer';

import 'package:bvu_dormitory/models/invoice.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/helpers/extensions/datetime.extensions.dart';
import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import '../rooms.detail.invoices.add.controller.dart';

class AdminRoomsDetailInvoicesAddPayments extends StatefulWidget {
  AdminRoomsDetailInvoicesAddPayments({Key? key}) : super(key: key);

  @override
  _AdminRoomsDetailInvoicesAddPaymentsState createState() => _AdminRoomsDetailInvoicesAddPaymentsState();
}

class _AdminRoomsDetailInvoicesAddPaymentsState extends State<AdminRoomsDetailInvoicesAddPayments> {
  late AdminRoomsDetailInvoicesAddController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = context.watch<AdminRoomsDetailInvoicesAddController>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColor.secondaryBackgroundColor(context.read<AppController>().appThemeMode),
        border: Border.all(width: 1, color: AppColor.borderColor(context.read<AppController>().appThemeMode)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _header(),
          Expanded(
            child: _paymentsList(),
          ),
          if (controller.student == null) ...{
            if (controller.invoice!.paid < controller.invoice!.total) ...{
              _addPaymentButton(),
            }
          },
        ],
      ),
    );
  }

  _header() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: AppColor.borderColor(context.read<AppController>().appThemeMode)),
        ),
        gradient: AppColor.mainAppBarGradientColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.admin_manage_invoice_cost_total,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
              Text(
                NumberFormat('#,###').format(controller.invoice!.total) + ' đ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.student_invoice_paid,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
              Text(
                NumberFormat('#,###').format(controller.invoice!.paid) + ' đ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.student_invoice_difference,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
              Text(
                NumberFormat('#,###').format(controller.invoice!.total - controller.invoice!.paid) + ' đ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _addPaymentButton() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      // color: Colors.white,
      child: Container(
        // padding: EdgeInsets.only(top: 5),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: AppColor.borderColor(context.read<AppController>().appThemeMode)),
          ),
          // gradient: AppColor.mainAppBarGradientColor,
        ),
        child: const Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Icon(FluentIcons.note_add_24_regular),
        ),
      ),
      onPressed: () {
        controller.showAddPaymentDialog();
      },
    );
  }

  _paymentsList() {
    return Scrollbar(
      child: ListView.builder(
        primary: false,
        itemCount: controller.invoice!.payments.length,
        itemBuilder: (context, index) {
          final thePayment = controller.invoice!.payments[index];

          return Material(
            color: Colors.transparent,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          thePayment.studentName,
                          style: const TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '+ ' + NumberFormat('#,###').format(thePayment.amount) + ' đ',
                          style: const TextStyle(
                            color: Colors.green,
                            // fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateTime.fromMillisecondsSinceEpoch(
                            thePayment.timestamp.millisecondsSinceEpoch,
                          ).getReadableDateString(),
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        Text(
                          thePayment.type.name,
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {
                controller.onPaymentItemPressed(index);
              },
            ),
          );
        },
      ),
    );
  }
}
