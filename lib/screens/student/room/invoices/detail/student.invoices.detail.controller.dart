import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/invoice.dart';
import 'package:bvu_dormitory/models/service.dart';

import 'widgets/student.invoices.detail.info.dart';
import 'widgets/student.invoices.detail.payments.dart';

class StudentInvoicesDetailController extends BaseController {
  StudentInvoicesDetailController({
    required BuildContext context,
    required String title,
    required this.invoice,
  }) : super(context: context, title: title) {
    dateController = TextEditingController(text: getDateStringFromDate(getDateFromDateString(invoice.createdDate)));
    notesController = TextEditingController(text: invoice.notes);

    segmentedControls = {
      0: StudentInvoicesDetailInfo(invoice: invoice),
      1: StudentInvoicesDetailPayments(invoice: invoice),
    };

    selectedSecmentWidget = segmentedControls.values.first;
  }

  late final Map<int, Widget> segmentedControls;
  late Widget selectedSecmentWidget;
  int _selectedSegment = 0;
  int get selectedSegment => _selectedSegment;
  set selectedSegment(int value) {
    _selectedSegment = value;

    selectedSecmentWidget = segmentedControls.values.elementAt(value);
    notifyListeners();
  }

  final Invoice invoice;

  DateTime? date;
  late TextEditingController dateController;
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
}
