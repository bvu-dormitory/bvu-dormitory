import 'dart:developer';

import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/invoice.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/service.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ','; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) && oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex = newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) {
          newString = separator + newString;
        }
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}

class AdminRoomsDetailInvoicesAddController extends BaseController {
  AdminRoomsDetailInvoicesAddController({
    required BuildContext context,
    required String title,
    required this.building,
    required this.floor,
    required this.room,
  }) : super(context: context, title: title) {
    dateController = TextEditingController(text: getDateStringFromDate(DateTime.now()));
    notesController = TextEditingController(text: "");

    addListener(() {
      reCalculateTotalCost();
    });
  }

  final Building building;
  final Floor floor;
  final Room room;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int totalCost = 2654000;

  DateTime? date;
  late TextEditingController dateController;
  void onDatePickerChanged(DateTime? value) {
    date = value;
    dateController.text = value == null ? "" : getDateStringFromDate(value);
    notifyListeners();
  }

  late TextEditingController notesController;
  // Tuple<Service, discount TextEditingController, newIndex TextEditingController (for continous Service)
  late List<Tuple3<Service, TextEditingController, TextEditingController?>> serviceControllers;

  String getDateStringFromDate(DateTime value) {
    return "${value.day.toString().padLeft(2, '0')}-${value.month.toString().padLeft(2, '0')}-${value.year}";
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
      createdDate: getDateStringFromDate(DateTime.now()),
      month: int.parse(month),
      year: int.parse(year),
      room: room.reference!,
      services: serviceControllers
          .map((e) => Service(
                name: e.item1.name,
                price: e.item1.price,
                unit: e.item1.unit,
                type: e.item1.type,
              ))
          .toList(),
    );
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      // checking if any service is of the continous type and not provided newIndex value
      if (serviceControllers.any((element) {
        return element.item1.type == ServiceType.continous && element.item3!.text.trim().isEmpty;
      })) {
        showSnackbar(appLocalizations!.app_form_validation_error, const Duration(seconds: 3), () {});
        return;
      }

      // form validated
      log('validated');
    }
  }
}
