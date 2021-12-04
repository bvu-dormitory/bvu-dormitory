import 'dart:developer';

import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/invoices/add/widgets/invoice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:printing/printing.dart';
import 'package:tuple/tuple.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/invoice.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/invoice.repository.dart';
import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/service.dart';

import 'widgets/payments.dart';

class AdminRoomsDetailInvoicesAddController extends BaseController {
  late dynamic currentSegmentWidget;
  var currentSegmentKey = 0;
  late final segmentKeys;
  late final _segmentWidgets;

  void updateCurrentSegment(Object? value) {
    currentSegmentWidget = _segmentWidgets[value];
    currentSegmentKey = value as int;
    notifyListeners();
  }

  AdminRoomsDetailInvoicesAddController({
    required BuildContext context,
    required String title,
    required this.room,
    this.invoice,
  }) : super(context: context, title: title) {
    notesController = TextEditingController(text: invoice?.notes);
    dateController = TextEditingController(
      text: getDateStringFromDate(invoice == null ? DateTime.now() : getDateFromDateString(invoice!.createdDate)),
    );

    currentSegmentWidget = AdminRoomsDetailInvoicesAddInvoice(invoice: invoice);
    segmentKeys = {
      0: Text(AppLocalizations.of(context)!.admin_manage_invoice_detail),
      1: Text(AppLocalizations.of(context)!.student_invoice_payments),
    };
    _segmentWidgets = {
      0: AdminRoomsDetailInvoicesAddInvoice(invoice: invoice),
      1: AdminRoomsDetailInvoicesAddPayments(),
    };

    Future.delayed(const Duration(seconds: 1), () {
      reCalculateTotalCost();
      notifyListeners();
    });

    addListener(() {
      // notifyListeners();
      reCalculateTotalCost();
    });
  }

  final Invoice? invoice;
  final Room room;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int totalCost = 0;

  DateTime? date;
  late TextEditingController dateController;
  void onDatePickerChanged(DateTime? value) {
    date = value;
    dateController.text = value == null ? "" : getDateStringFromDate(value);
    notifyListeners();
  }

  late TextEditingController notesController;
  // Tuple<Service, discounts TextEditingController, newIndex TextEditingController (for continous Service)
  late List<Tuple3<Service, TextEditingController, TextEditingController?>> serviceControllers;

  String getDateStringFromDate(DateTime value) {
    return "${value.day.toString().padLeft(2, '0')}-${value.month.toString().padLeft(2, '0')}-${value.year}";
  }

  DateTime getDateFromDateString(String value) {
    final splitted = value.split('-');
    return DateTime(int.parse(splitted[2]), int.parse(splitted[1]), int.parse(splitted[0]));
  }

  String getServiceSubtotal(Service service, int index) {
    var subTotal = 0;
    final discounts = int.tryParse(serviceControllers[index].item2.text.split(',').join('')) ?? 0;

    if (service.type == ServiceType.seperated) {
      subTotal = service.price - discounts;
    } else {
      final newIndex = int.tryParse(serviceControllers[index].item3!.text) ?? 0;
      subTotal = service.price * newIndex - discounts;
    }

    return NumberFormat('#,###').format(subTotal) + ' đ';
  }

  void reCalculateTotalCost() {
    totalCost = serviceControllers.map((e) {
      // e.item1: Service
      // e.item2: discounts TextEditingController
      // e.item3: newIndex TextEditingController

      var sum = 0;

      if (e.item1.type == ServiceType.seperated) {
        // service.price - discount
        sum = e.item1.price;
      }
      // continous service
      else {
        final newIndex = int.tryParse(e.item3?.text ?? "") ?? 0;

        // old index of this invoice is new index of the lastest invoice
        final oldIndex = e.item1.newIndex ?? 0;

        // service.price * (newIndex - oldIndex)
        sum = e.item1.price * (newIndex - oldIndex);
      }

      // minusing the discount
      final discounts = int.tryParse(e.item2.text.split(',').join('')) ?? 0;

      return sum - discounts;
    }).reduce((value, element) => value + element);

    // log('total cost changed: ' + totalCost.toString());
    // notifyListeners();
  }

  Invoice getFormValue() {
    final createDate = dateController.text.split('-');
    final year = createDate.last;
    final month = createDate[1];

    return Invoice(
      createdDate: getDateStringFromDate(getDateFromDateString(dateController.text)),
      month: int.parse(month),
      year: int.parse(year),
      room: room.reference!,
      payments: [],
      notes: notesController.text,
      services: serviceControllers.map((e) {
        final s = Service(
          name: e.item1.name,
          price: e.item1.price,
          unit: e.item1.unit,
          type: e.item1.type,
          discounts: int.tryParse(e.item2.text.split(',').join('')),
          oldIndex: e.item1.newIndex,
          newIndex: int.tryParse(e.item3?.text ?? ""),
        );

        return s;
      }).toList(),
    );
  }

  void submit() async {
    if (formKey.currentState!.validate()) {
      // checking if any service is of the continous type and not provided newIndex value
      if (serviceControllers.any((element) {
        return element.item1.type == ServiceType.continous && element.item3!.text.trim().isEmpty;
      })) {
        showSnackbar(appLocalizations!.app_form_validation_error, const Duration(seconds: 3), () {});
        return;
      }

      // form validated
      if (await hasConnectivity()) {
        showLoadingDialog();

        try {
          await InvoiceRepository.addInvoice(getFormValue());
          navigator.pop();
        } catch (e) {
          showSnackbar(e.toString(), const Duration(seconds: 5), () {});
          log(e.toString());
        } finally {
          navigator.pop();
        }
      }
    }
  }

  deleteInvoice(Invoice invoice) async {
    showConfirmDialog(
        title: appLocalizations!.app_dialog_title_delete,
        confirmType: DialogConfirmType.submit,
        onSubmit: () async {
          if (await hasConnectivity()) {
            try {
              await InvoiceRepository.deleteInvoice(invoice);
              navigator.pop();
            } catch (e) {
              showSnackbar(e.toString(), const Duration(seconds: 5), () {});
            } finally {
              navigator.pop();
            }
          }
        });
  }

  /// generating a PDF file and open print dialog
  void print() async {
    // showLoadingDialog();

    try {
      final pdf = await getInvoicePDF();

      // getting the internal storage path
      // Directory internalDirectory = await getApplicationDocumentsDirectory();
      // String tempPath = internalDirectory.path;
      // String filePath = '$tempPath/invoice';

      // await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      //   log('saving to printer...');
      //   return pdf.save();
      // });
      showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      appLocalizations!.admin_manage_invoice_print,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(AntDesign.close, size: 20),
                      onPressed: () => navigator.pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PdfPreview(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  build: (format) => pdf.save(),
                ),
              ),
            ],
          ),
        ),
      );
      // await Printing.sharePdf(bytes: await pdf.save(), filename: 'my-document.pdf');
    } catch (e) {
      showSnackbar(e.toString(), const Duration(seconds: 5), () {});
      log(e.toString());
    } finally {
      log('message');
      // navigator.pop();
    }
  }

  Future<pw.Document> getInvoicePDF() async {
    final pdf = pw.Document();

    // final fontData = await rootBundle.load('lib/assets/fonts/OpenSans.ttf');
    final fontData = await PdfGoogleFonts.montserratRegular();
    // final ttf = pw.Font.ttf(fontData);

    final theInvoice = getFormValue();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Center(
                child: pw.Text(
                  "Hóa đơn tiền phòng",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 30, font: fontData),
                ),
              ),

              // address
              pw.SizedBox(height: 50),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    appLocalizations!.admin_manage_room + " " + room.name,
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20, font: fontData),
                  ),
                  pw.Text(
                    "${appLocalizations!.admin_manage_invoice_month(theInvoice.month)}, ${theInvoice.year}",
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20, font: fontData),
                  ),
                ],
              ),

              pw.SizedBox(height: 50),
              pw.Table(
                children: [
                  // table header rows
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(width: 0.5),
                    ),
                    children: [
                      // pw.Padding(),
                      pw.Text(
                        appLocalizations!.admin_manage_service,
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontData),
                      ),
                      pw.Text(
                        appLocalizations!.admin_manage_service_unit_compact,
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontData),
                      ),
                      pw.Text(
                        appLocalizations!.admin_manage_service_price_compact,
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontData),
                      ),
                      pw.Text(
                        appLocalizations!.admin_manage_invoice_cost_discount,
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontData),
                      ),
                      pw.Text(
                        appLocalizations!.admin_manage_invoice_cost_subtotal,
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontData),
                      ),
                    ],
                  ),

                  // services rows
                  ...List.generate(serviceControllers.length, (index) {
                    final theService = serviceControllers[index];
                    return pw.TableRow(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 0.5),
                      ),
                      children: [
                        // pw.Padding(),
                        pw.Text(theService.item1.name,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, font: fontData)),
                        pw.Text(theService.item1.unit,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, font: fontData)),
                        pw.Text(
                          NumberFormat('#,###').format(theService.item1.price) + ' đ',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, font: fontData),
                        ),
                        pw.Text(
                          NumberFormat('#,###').format(int.parse(theService.item2.text.replaceAll(',', ""))) + ' đ',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, font: fontData),
                        ),
                        pw.Text(
                          getServiceSubtotal(theService.item1, index),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, font: fontData),
                        ),
                      ],
                    );
                  }),
                ],
              ),

              pw.SizedBox(height: 50),

              // total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    appLocalizations!.admin_manage_invoice_cost_total,
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20, font: fontData),
                  ),
                  pw.Text(
                    NumberFormat('#,###').format(getFormValue().total) + ' đ',
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20, font: fontData),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ); // Pa

    return pdf;
  }
}
