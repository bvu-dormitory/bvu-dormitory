import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:spannable_grid/spannable_grid.dart';
import 'package:tuple/tuple.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/room.repository.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/invoices/add/widgets/invoice.dart';
import 'package:bvu_dormitory/widgets/app.form.field.dart';
import 'package:bvu_dormitory/widgets/app.form.picker.dart';
import 'package:bvu_dormitory/widgets/app.thousand_seperator.dart';
import 'package:bvu_dormitory/models/invoice.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/invoice.repository.dart';
import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/service.dart';

class AdminRoomsDetailInvoicesAddController extends BaseController {
  late dynamic currentSegmentWidget;
  var currentSegmentKey = 0;
  late final segmentKeys;

  var flipController = FlipCardController();

  void updateCurrentSegment(Object? value) {
    // currentSegmentWidget = _segmentWidgets[value];
    flipController.toggleCard();

    currentSegmentKey = value as int;
    notifyListeners();
  }

  AdminRoomsDetailInvoicesAddController({
    required BuildContext context,
    required String title,
    required this.room,
    this.invoice,
    this.student,
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
  final Student? student;

  // for payment form
  late GlobalKey<FormState> paymentFormKey;
  late TextEditingController paymentPayerController;
  late TextEditingController paymentAmountController;
  late TextEditingController paymentNotesController;

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
      final oldIndex = service.oldIndex ?? 0;
      subTotal = (service.price * (newIndex - oldIndex)) - discounts;
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
        final oldIndex = e.item1.oldIndex ?? 0;

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
          oldIndex: e.item1.oldIndex,
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
          final invoiceToAdd = getFormValue();

          if (await InvoiceRepository.invoiceIsNotDuplicate(
              roomRef: room.reference!, month: invoiceToAdd.month, year: invoiceToAdd.year)) {
            await InvoiceRepository.addInvoice(invoiceToAdd);
            navigator.pop();
          } else {
            showSnackbar(appLocalizations!.admin_manage_invoice_duplicated_time, const Duration(seconds: 5), () {});
          }
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

  ///
  /// generating a PDF file and open print dialog
  void print() async {
    // showLoadingDialog();

    try {
      final pdf = await getInvoicePDF();

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
                  "Giấy báo tiền phòng",
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
                  ////////////////////////////////////////////////////////////////////////
                  /// table header rows
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

                      // continous services
                      pw.Text(
                        appLocalizations!.admin_manage_invoice_old_index,
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontData),
                      ),
                      pw.Text(
                        appLocalizations!.admin_manage_invoice_new_index,
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

                  /////////////////////////////////
                  // services rows
                  ...List.generate(serviceControllers.length, (index) {
                    final theService = serviceControllers[index];
                    return pw.TableRow(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 0.5),
                      ),
                      children: [
                        // pw.Padding(),
                        pw.Text(
                          theService.item1.name,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontData),
                        ),
                        pw.Text(
                          theService.item1.unit,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontData),
                        ),

                        // continous servicess
                        if (theService.item1.type == ServiceType.continous) ...{
                          pw.Text(
                            (theService.item1.oldIndex ?? 0).toString(),
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontData),
                          ),
                          pw.Text(
                            (theService.item1.newIndex ?? 0).toString(),
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontData),
                          ),
                        } else ...{
                          pw.Text(
                            "",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontData),
                          ),
                          pw.Text(
                            "",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontData),
                          ),
                        },

                        pw.Text(
                          NumberFormat('#,###').format(theService.item1.price) + ' đ',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontData),
                        ),
                        pw.Text(
                          NumberFormat('#,###').format(int.parse(theService.item2.text.replaceAll(',', ""))) + ' đ',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontData),
                        ),
                        pw.Text(
                          getServiceSubtotal(theService.item1, index),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontData),
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

  ///
  /// payments
  void showAddPaymentDialog({int? paymentIndex}) {
    final payment = paymentIndex != null ? invoice!.payments[paymentIndex] : null;

    paymentFormKey = GlobalKey<FormState>();
    paymentPayerController = TextEditingController(text: payment?.studentName);
    paymentAmountController = TextEditingController(
      text: payment != null ? NumberFormat('#,###').format(payment.amount) : "",
    );
    paymentNotesController = TextEditingController(text: payment?.notes);

    _body() {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            StreamBuilder<List<Student>>(
              stream: RoomRepository.syncStudentsInRoom(room),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
                }

                if (snapshot.hasData) {
                  final studentsList = snapshot.data!;

                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Form(
                      key: paymentFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SpannableGrid(
                        editingOnLongPress: false,
                        columns: 1,
                        rows: 4,
                        rowHeight: 100,
                        cells: [
                          SpannableGridCellData(
                            id: 1,
                            column: 1,
                            row: 1,
                            child: AppFormField(
                              label: appLocalizations!.admin_manage_invoice_payer,
                              maxLength: 50,
                              context: context,
                              required: true,
                              editable: false,
                              controller: paymentPayerController,
                              prefixIcon: const Icon(FluentIcons.person_24_regular, size: 20),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return appLocalizations!.app_form_field_required;
                                }
                              },
                              type: payment == null ? AppFormFieldType.picker : AppFormFieldType.normal,
                              picker: AppFormPicker(
                                type: AppFormPickerFieldType.custom,
                                dataList: snapshot.data!.map((e) => e.fullName).toList(),
                                required: true,
                                onSelectedItemChanged: (index) {
                                  paymentPayerController.text = index == null ? "" : studentsList[index].fullName;
                                },
                              ),
                            ),
                          ),
                          SpannableGridCellData(
                            id: 2,
                            column: 1,
                            row: 2,
                            child: AppFormField(
                              label: appLocalizations!.admin_manage_invoice_payer_amount,
                              maxLength: 10,
                              required: true,
                              keyboardType: TextInputType.number,
                              context: context,
                              controller: paymentAmountController,
                              editable: payment == null,
                              prefixIcon: const Icon(FluentIcons.number_symbol_24_regular, size: 20),
                              formatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                ThousandsSeparatorInputFormatter(),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return appLocalizations!.app_form_field_required;
                                }
                              },
                            ),
                          ),
                          SpannableGridCellData(
                            id: 3,
                            column: 1,
                            row: 3,
                            rowSpan: 2,
                            child: AppFormField(
                              label: appLocalizations!.admin_manage_invoice_notes,
                              maxLength: 100,
                              maxLines: 5,
                              editable: payment == null,
                              keyboardAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,
                              context: context,
                              controller: paymentNotesController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return const CupertinoActivityIndicator(radius: 10);
              },
            ),

            // footer buttons
            if (payment == null) ...{
              CupertinoButton(
                child: Text(appLocalizations!.admin_manage_invoice_payment_submit),
                onPressed: () {
                  if (paymentFormKey.currentState!.validate()) {
                    // form validated, lets submit the payment
                    log('submitting payment...');
                    _submitPayment(
                      InvoicePayment(
                        amount: int.parse(paymentAmountController.text.replaceAll(',', '')),
                        type: InvoicePaymentType.cash,
                        notes: paymentNotesController.text.trim(),
                        studentName: paymentPayerController.text.trim(),
                        timestamp: Timestamp.fromDate(DateTime.now()),
                      ),
                    );
                  }
                },
              ),
            } else ...{
              if (student == null) ...{
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(FluentIcons.delete_24_regular, color: Colors.red),
                  onPressed: () {
                    _deletePayment(paymentIndex!);
                  },
                ),
              },
            },
          ],
        ),
      );
    }

    showCupertinoModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 10),
        physics: const ClampingScrollPhysics(),
        child: Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom:
                        BorderSide(width: 1, color: AppColor.borderColor(context.read<AppController>().appThemeMode)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      paymentIndex == null
                          ? appLocalizations!.admin_manage_invoice_payment_add
                          : appLocalizations!.student_invoice_payments,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(AntDesign.close),
                      onPressed: () => navigator.pop(),
                    ),
                  ],
                ),
              ),

              _body(),
            ],
          ),
        ),
      ),
    );
  }

  _submitPayment(InvoicePayment payment) async {
    try {
      await InvoiceRepository.addPayment(payment: payment, invoice: invoice!);
      showSnackbar(appLocalizations!.admin_manage_invoice_payment_success, const Duration(seconds: 3), () {});
    } catch (e) {
      showSnackbar(e.toString(), const Duration(seconds: 5), () {});
    } finally {
      navigator.pop();
      notifyListeners();
    }
  }

  void _deletePayment(int paymentIndex) async {
    try {
      await InvoiceRepository.deletePayment(paymentIndex: paymentIndex, invoice: invoice!);
      showSnackbar(appLocalizations!.admin_manage_invoice_payment_deleted, const Duration(seconds: 3), () {});
    } catch (e) {
      showSnackbar(e.toString(), const Duration(seconds: 5), () {});
    } finally {
      navigator.pop();
      notifyListeners();
    }
  }

  void onPaymentItemPressed(int index) {
    showAddPaymentDialog(paymentIndex: index);
  }
}
