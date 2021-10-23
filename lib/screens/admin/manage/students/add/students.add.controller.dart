import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/user.dart';

class AdminStudentsAddController extends BaseController {
  AdminStudentsAddController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title) {
    genderFieldController = TextEditingController();
    dobFieldController = TextEditingController();
  }

  final GlobalKey _formKey = GlobalKey<FormState>();
  GlobalKey get formKey => _formKey;

  final TextEditingController lastNameFieldController = TextEditingController();
  final TextEditingController firstNameFieldController =
      TextEditingController();
  late final TextEditingController genderFieldController;
  late final TextEditingController dobFieldController;
  final TextEditingController phoneFieldController = TextEditingController();
  final TextEditingController homeTownFieldController = TextEditingController();

  /// Available gender names
  final List<String> genderValues =
      UserGender.values.map((e) => e.name).toList();

  /// Gender value
  String _gender = "";
  String get gender => _gender;
  void onGenderPickerSelectedIndexChanged(int index) {
    log("$index");
    _gender = genderValues[index];
    notifyListeners();
  }

  /// Date of Birth value
  DateTime _dateOfBirth = DateTime(2000, 1, 1);
  DateTime get dateOfBirth => _dateOfBirth;
  void ondateOfBirthPickerSelectedIndexChanged(DateTime date) {
    _dateOfBirth = date;
    dobFieldController.text =
        "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
    notifyListeners();
  }

  submit() {
    log('submit...');

    // if (formKey.) {

    // }
  }
}
