import 'dart:developer';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

enum StudentFormFieldPickerType {
  date,
  gender,
}

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
  final List<TextInputFormatter>? formatters;
  final int maxLength;
  final IconData? icon;
  final StudentFormFieldPickerType? pickerType;
  final List<dynamic>? pickerData;
  final void Function(dynamic)? onPickerSelectedItemChanged;
  final dynamic pickerInitialData;

  StudentProfileFormField({
    required this.label,
    required this.controller,
    required this.colStart,
    this.colSpan = 1,
    required this.rowStart,
    this.type = TextInputType.text,
    this.required = false,
    this.editable = true,
    this.validator,
    this.icon,
    required this.maxLength,
    this.formatters,
    this.onTap,
    this.pickerData,
    this.pickerType,
    this.pickerInitialData,
    this.onPickerSelectedItemChanged,
  });
}

class AdminStudentsAddController extends BaseController {
  AdminStudentsAddController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  bool _continueButtonEnabled = true;
  bool get continueButtonEnabled => _continueButtonEnabled;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  List<StudentProfileFormField> get formFields => [
        lastNameField,
        firstNameField,
        genderField,
        dobField,
        homeTownField,
        idField,
        phoneField,
        parentPhoneField,
        mssvField,
        joinDateField,
        outDateField,
        notesField,
      ];

  bool get isFormEmpty => formControllers.every((element) => element.text.isEmpty);
  List<TextEditingController> get formControllers => [
        genderController,
        lastNameController,
        firstNameController,
        dobController,
        homeTownController,
        idController,
        phoneController,
        parentPhoneController,
        mssvController,
        joinDateController,
        outDateController,
        notesController,
      ];

  final genderController = TextEditingController();
  final lastNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final dobController = TextEditingController();
  final homeTownController = TextEditingController();
  final idController = TextEditingController();
  final phoneController = TextEditingController();
  final parentPhoneController = TextEditingController();
  final mssvController = TextEditingController();
  final joinDateController = TextEditingController();
  final outDateController = TextEditingController();
  final notesController = TextEditingController();

  StudentProfileFormField get lastNameField => StudentProfileFormField(
        label: appLocalizations!.admin_manage_student_menu_add_field_last_name,
        controller: lastNameController,
        colStart: 1,
        rowStart: 1,
        colSpan: 2,
        required: true,
        type: TextInputType.name,
        maxLength: 30,
        icon: FluentIcons.text_field_24_regular,
        formatters: [],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return appLocalizations!.admin_manage_student_menu_add_validation_failed_required;
          }
        },
      );

  StudentProfileFormField get firstNameField => StudentProfileFormField(
        label: appLocalizations!.admin_manage_student_menu_add_field_first_name,
        controller: firstNameController,
        colStart: 3,
        rowStart: 1,
        colSpan: 2,
        maxLength: 20,
        required: true,
        icon: FluentIcons.text_field_24_regular,
        type: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return appLocalizations!.admin_manage_student_menu_add_validation_failed_required;
          }
        },
      );

  StudentProfileFormField get genderField => StudentProfileFormField(
        label: appLocalizations!.admin_manage_student_menu_add_field_gender,
        controller: genderController,
        colStart: 1,
        rowStart: 2,
        colSpan: 2,
        required: true,
        editable: false,
        icon: FluentIcons.people_24_regular,
        maxLength: 10,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return appLocalizations!.admin_manage_student_menu_add_validation_failed_required;
          }
        },
        pickerType: StudentFormFieldPickerType.gender,
        pickerData: genderValues,
        onPickerSelectedItemChanged: onGenderPickerSelectedIndexChanged,
      );

  StudentProfileFormField get dobField => StudentProfileFormField(
        label: appLocalizations!.admin_manage_student_menu_add_field_dob,
        controller: dobController,
        colStart: 3,
        rowStart: 2,
        colSpan: 2,
        required: true,
        editable: false,
        maxLength: 10,
        icon: FluentIcons.food_cake_24_regular,
        pickerType: StudentFormFieldPickerType.date,
        onPickerSelectedItemChanged: onDateOfBirthPickerSelectedIndexChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return appLocalizations!.admin_manage_student_menu_add_validation_failed_required;
          }
        },
      );

  StudentProfileFormField get homeTownField => StudentProfileFormField(
        label: appLocalizations!.admin_manage_student_menu_add_field_hometown,
        controller: homeTownController,
        colStart: 1,
        rowStart: 3,
        colSpan: 4,
        required: true,
        maxLength: 100,
        icon: FluentIcons.globe_24_regular,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return appLocalizations!.admin_manage_student_menu_add_validation_failed_required;
          }
        },
      );

  StudentProfileFormField get idField => StudentProfileFormField(
        label: appLocalizations!.admin_manage_student_menu_add_field_id,
        controller: idController,
        colStart: 1,
        rowStart: 4,
        colSpan: 4,
        required: true,
        maxLength: 20,
        icon: FluentIcons.phone_24_regular,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return appLocalizations!.admin_manage_student_menu_add_validation_failed_required;
          }
        },
      );

  StudentProfileFormField get phoneField => StudentProfileFormField(
        label: appLocalizations!.admin_manage_student_menu_add_field_phone,
        controller: phoneController,
        colStart: 1,
        rowStart: 5,
        colSpan: 4,
        required: true,
        maxLength: 10,
        icon: FluentIcons.call_24_regular,
        type: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return appLocalizations!.admin_manage_student_menu_add_validation_failed_required;
          }
        },
      );

  StudentProfileFormField get parentPhoneField => StudentProfileFormField(
        label: appLocalizations!.admin_manage_student_menu_add_field_parent_phone,
        controller: parentPhoneController,
        colStart: 1,
        rowStart: 6,
        colSpan: 4,
        maxLength: 10,
        icon: FluentIcons.call_transfer_20_regular,
        type: TextInputType.number,
      );

  StudentProfileFormField get mssvField => StudentProfileFormField(
        label: appLocalizations!.admin_manage_student_menu_add_field_mssv,
        controller: mssvController,
        colStart: 1,
        rowStart: 7,
        colSpan: 4,
        maxLength: 15,
        icon: FluentIcons.hat_graduation_24_regular,
      );

  StudentProfileFormField get joinDateField => StudentProfileFormField(
        label: appLocalizations!.admin_manage_student_menu_add_field_join_date,
        controller: joinDateController,
        colStart: 1,
        rowStart: 8,
        colSpan: 2,
        required: true,
        editable: false,
        maxLength: 10,
        icon: FluentIcons.calendar_arrow_down_24_regular,
        pickerType: StudentFormFieldPickerType.date,
        onPickerSelectedItemChanged: onJoinDatePickerSelectedIndexChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return appLocalizations!.admin_manage_student_menu_add_validation_failed_required;
          }
        },
      );

  StudentProfileFormField get outDateField => StudentProfileFormField(
      label: appLocalizations!.admin_manage_student_menu_add_field_out_date,
      controller: outDateController,
      colStart: 3,
      rowStart: 8,
      colSpan: 2,
      editable: false,
      maxLength: 10,
      icon: FluentIcons.calendar_arrow_right_20_regular,
      pickerType: StudentFormFieldPickerType.date,
      onPickerSelectedItemChanged: onOutDatePickerSelectedIndexChanged);

  StudentProfileFormField get notesField => StudentProfileFormField(
        label: appLocalizations!.admin_manage_student_menu_add_field_notes,
        controller: notesController,
        colStart: 1,
        rowStart: 9,
        colSpan: 4,
        maxLength: 255,
        icon: FluentIcons.comment_24_regular,
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
  void onGenderPickerSelectedIndexChanged(dynamic index) {
    _gender = genderValues[index];
    log("$index");
    genderField.controller.text = _gender;
    notifyListeners();
  }

  /// Date of Birth value
  DateTime? _dateOfBirth = DateTime(2000, 1, 1);
  DateTime? get dateOfBirth => _dateOfBirth;
  void onDateOfBirthPickerSelectedIndexChanged(dynamic date) {
    _dateOfBirth = date;
    dobField.controller.text = date == null ? "" : getDateStringValue(date);
    notifyListeners();
  }

  /// join date value
  DateTime? _joinDate = DateTime(2000, 1, 1);
  DateTime? get joinDate => _joinDate;
  void onJoinDatePickerSelectedIndexChanged(dynamic date) {
    _joinDate = date;
    joinDateField.controller.text = date == null ? "" : getDateStringValue(date);
    notifyListeners();
  }

  /// out date value
  DateTime? _outDate = DateTime(2000, 1, 1);
  DateTime? get outDate => _outDate;
  void onOutDatePickerSelectedIndexChanged(dynamic date) {
    _outDate = date;
    outDateField.controller.text = date == null ? "" : getDateStringValue(date);
    notifyListeners();
  }

  String getDateStringValue(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  submit() {
    if (formKey.currentState!.validate()) {
      // process
    } else {
      _continueButtonEnabled = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(
            appLocalizations!.admin_manage_student_menu_add_validation_failed,
            textAlign: TextAlign.center,
          ),
          onVisible: () {
            Future.delayed(const Duration(seconds: 3), () {
              _continueButtonEnabled = true;
              notifyListeners();
            });
          },
        ),
      );
    }
  }
}
