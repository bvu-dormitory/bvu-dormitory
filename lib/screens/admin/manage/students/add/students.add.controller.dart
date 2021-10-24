import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:flutter/services.dart';

class StudentProfileFormField {
  final int colStart;
  final int rowStart;
  final int colSpan;
  final TextEditingController controller;
  final bool required;
  final String label;
  final bool editable;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final TextInputType type;

  StudentProfileFormField({
    required this.label,
    required this.controller,
    required this.colStart,
    this.colSpan = 1,
    required this.rowStart,
    this.type = TextInputType.text,
    this.required = false,
    this.editable = true,
    required this.validator,
    this.onTap,
  });
}

class AdminStudentsAddController extends BaseController {
  AdminStudentsAddController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  final GlobalKey _formKey = GlobalKey<FormState>();
  GlobalKey get formKey => _formKey;

  List<StudentProfileFormField> get formFields => [
        lastNameField,
        firstNameField,
        genderField,
        dobField,
        homeTownField,
        idField,
        phoneField,
        parentPhoneField,
        joinDateField,
        outDateField,
        notesField,
      ];

  StudentProfileFormField get lastNameField => StudentProfileFormField(
        label: appLocalizations?.admin_manage_student_menu_add_field_last_name ?? "admin_manage_student_menu_add_field_last_name",
        controller: TextEditingController(),
        colStart: 1,
        rowStart: 1,
        colSpan: 2,
        required: true,
        type: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please fill out this field.";
          }
        },
      );

  StudentProfileFormField get firstNameField => StudentProfileFormField(
        label: appLocalizations?.admin_manage_student_menu_add_field_first_name ?? "admin_manage_student_menu_add_field_first_name",
        controller: TextEditingController(),
        colStart: 3,
        rowStart: 1,
        colSpan: 2,
        required: true,
        type: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please fill out this field.";
          }
        },
      );

  StudentProfileFormField get genderField => StudentProfileFormField(
        label: appLocalizations?.admin_manage_student_menu_add_field_gender ?? "admin_manage_student_menu_add_field_gender",
        controller: TextEditingController(),
        colStart: 1,
        rowStart: 2,
        colSpan: 2,
        required: true,
        editable: false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please fill out this field.";
          }
        },
        onTap: () {
          // showCupertinoModalPopup(
          //   context: context,
          //   builder: (context) => _datePicker(
          //     onValueChanged: controller.onDateOfBirthPickerSelectedIndexChanged,
          //     onDeleteButtonPressed: () => controller.onDateOfBirthPickerSelectedIndexChanged(null),
          //   ),
          // );
        },
      );

  StudentProfileFormField get dobField => StudentProfileFormField(
        label: appLocalizations?.admin_manage_student_menu_add_field_dob ?? "admin_manage_student_menu_add_field_dob",
        controller: TextEditingController(),
        colStart: 3,
        rowStart: 2,
        colSpan: 2,
        required: true,
        editable: false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please fill out this field.";
          }
        },
      );

  StudentProfileFormField get homeTownField => StudentProfileFormField(
        label: appLocalizations?.admin_manage_student_menu_add_field_hometown ?? "admin_manage_student_menu_add_field_hometown",
        controller: TextEditingController(),
        colStart: 1,
        rowStart: 3,
        colSpan: 4,
        required: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please fill out this field.";
          }
        },
      );

  StudentProfileFormField get idField => StudentProfileFormField(
        label: appLocalizations?.admin_manage_student_menu_add_field_id ?? "admin_manage_student_menu_add_field_id",
        controller: TextEditingController(),
        colStart: 1,
        rowStart: 4,
        colSpan: 4,
        required: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please fill out this field.";
          }
        },
      );

  StudentProfileFormField get phoneField => StudentProfileFormField(
        label: appLocalizations?.admin_manage_student_menu_add_field_phone ?? "admin_manage_student_menu_add_field_phone",
        controller: TextEditingController(),
        colStart: 1,
        rowStart: 5,
        colSpan: 4,
        required: true,
        type: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please fill out this field.";
          }
        },
      );

  StudentProfileFormField get parentPhoneField => StudentProfileFormField(
        label: appLocalizations?.admin_manage_student_menu_add_field_parent_phone ?? "admin_manage_student_menu_add_field_parent_phone",
        controller: TextEditingController(),
        colStart: 1,
        rowStart: 6,
        colSpan: 4,
        type: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please fill out this field.";
          }
        },
      );

  StudentProfileFormField get joinDateField => StudentProfileFormField(
        label: appLocalizations?.admin_manage_student_menu_add_field_join_date ?? "admin_manage_student_menu_add_field_join_date",
        controller: TextEditingController(),
        colStart: 1,
        rowStart: 7,
        colSpan: 2,
        required: true,
        editable: false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please fill out this field.";
          }
        },
      );

  StudentProfileFormField get outDateField => StudentProfileFormField(
        label: appLocalizations?.admin_manage_student_menu_add_field_out_date ?? "admin_manage_student_menu_add_field_out_date",
        controller: TextEditingController(),
        colStart: 3,
        rowStart: 7,
        colSpan: 2,
        required: true,
        editable: false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please fill out this field.";
          }
        },
      );

  StudentProfileFormField get notesField => StudentProfileFormField(
        label: appLocalizations?.admin_manage_student_menu_add_field_notes ?? "admin_manage_student_menu_add_field_hometown",
        controller: TextEditingController(),
        colStart: 1,
        rowStart: 8,
        colSpan: 4,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please fill out this field.";
          }
        },
      );

  ///
  ///
  ///
  ///
  /// Available gender names
  final List<String> genderValues = UserGender.values.map((e) => e.name).toList();

  /// Gender value
  String _gender = "";
  String get gender => _gender;
  void onGenderPickerSelectedIndexChanged(int index) {
    _gender = genderValues[index];
    genderField.controller.text = _gender;
    notifyListeners();
  }

  /// Date of Birth value
  DateTime? _dateOfBirth = DateTime(2000, 1, 1);
  DateTime? get dateOfBirth => _dateOfBirth;
  void onDateOfBirthPickerSelectedIndexChanged(DateTime? date) {
    _dateOfBirth = date;
    dobField.controller.text = date == null ? "" : getDateStringValue(date);
    notifyListeners();
  }

  /// join date value
  DateTime? _joinDate = DateTime(2000, 1, 1);
  DateTime? get joinDate => _joinDate;
  void onJoinDatePickerSelectedIndexChanged(DateTime? date) {
    _joinDate = date;
    joinDateField.controller.text = date == null ? "" : getDateStringValue(date);
    notifyListeners();
  }

  /// out date value
  DateTime? _outDate = DateTime(2000, 1, 1);
  DateTime? get outDate => _outDate;
  void onOutDatePickerSelectedIndexChanged(DateTime? date) {
    _outDate = date;
    outDateField.controller.text = date == null ? "" : getDateStringValue(date);
    notifyListeners();
  }

  String getDateStringValue(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  submit() {
    log('submit...');

    // if (formKey.) {

    // }
  }
}
