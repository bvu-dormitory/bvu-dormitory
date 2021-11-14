import 'package:flutter/material.dart';

import 'package:bvu_dormitory/base/base.controller.dart';

class AdminRoomsDetailInvoicesAddController extends BaseController {
  AdminRoomsDetailInvoicesAddController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title) {
    dateController = TextEditingController(text: getDateStringFromDate(DateTime.now()));
    notesController = TextEditingController(text: "");
  }

  double totalCost = 2654000;

  DateTime? date;
  late TextEditingController dateController;
  void onDatePickerChanged(DateTime? value) {
    date = value;
    dateController.text = value == null ? "" : getDateStringFromDate(value);
    notifyListeners();
  }

  late TextEditingController notesController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String getDateStringFromDate(DateTime value) {
    return "${value.day.toString().padLeft(2, '0')}-${value.month.toString().padLeft(2, '0')}-${value.year}";
  }
}
