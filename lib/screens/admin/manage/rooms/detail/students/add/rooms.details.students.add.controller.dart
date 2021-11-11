import 'dart:developer';

import 'package:bvu_dormitory/widgets/app.form.field.dart';
import 'package:bvu_dormitory/widgets/app.form.picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bvu_dormitory/helpers/extensions/string.extensions.dart';
import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/user.dart';

import 'package:bvu_dormitory/repositories/auth.repository.dart';
import 'package:bvu_dormitory/repositories/student.repository.dart';
import 'package:spannable_grid/spannable_grid.dart';

class AdminRoomsDetailStudentsAddController extends BaseController {
  AdminRoomsDetailStudentsAddController({
    required BuildContext context,
    required this.previousPageTitle,
    required String title,
    required this.building,
    required this.floor,
    required this.room,
    this.student,
  }) : super(context: context, title: title) {
    genderValues = UserGender.values.map((e) => e.name).toList();
    genderValues.insert(0, "");

    if (student != null) {
      log(student!.notes ?? "notes empty");

      genderController = TextEditingController(
        text: UserGender.values
            .firstWhere((element) => element.name == student!.gender, orElse: () => UserGender.male)
            .name,
      );
      lastNameController = TextEditingController(text: student!.lastName);
      firstNameController = TextEditingController(text: student!.firstName);
      dobController = TextEditingController(text: student!.birthDate);
      homeTownController = TextEditingController(text: student!.hometown);
      idController = TextEditingController(text: student!.citizenIdNumber);
      phoneController = TextEditingController(text: student!.phoneNumber!.replaceFirst("+84", "0"));
      parentPhoneController = TextEditingController(text: student!.parentPhoneNumber ?? "");
      mssvController = TextEditingController(text: student!.studentIdNumber ?? "");
      joinDateController = TextEditingController(text: student!.joinDate);
      outDateController = TextEditingController(text: student!.outDate);
      notesController = TextEditingController(text: student!.notes);
    } else {
      isViewing = false;
      isFormEditing = true;

      _dateOfBirth = DateTime(2000, 9, 1);

      genderController = TextEditingController(text: UserGender.male.name);
      lastNameController = TextEditingController(text: "Nguyễn");
      firstNameController = TextEditingController(text: "Anh Tuấn");
      dobController = TextEditingController(text: "01-09-2000");
      homeTownController = TextEditingController(text: "Thanh Hóa");
      idController = TextEditingController(text: "038200016566");
      phoneController = TextEditingController(text: "0333326585");
      parentPhoneController = TextEditingController();
      mssvController = TextEditingController();
      joinDateController =
          TextEditingController(text: "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
      outDateController = TextEditingController();
      notesController = TextEditingController();
    }
  }

  String previousPageTitle;
  Building building;
  Floor floor;
  Room room;
  Student? student;

  // check whether is viewing or adding a new student
  bool _isViewing = true;
  bool get isViewing => _isViewing;
  set isViewing(bool viewing) {
    _isViewing = viewing;
    notifyListeners();
  }

  // check whether the form is editing
  bool _isFormEditing = false;
  bool get isFormEditing => _isFormEditing;
  set isFormEditing(bool editing) {
    _isFormEditing = editing;
    notifyListeners();
  }

  bool _continueButtonEnabled = true;
  bool get continueButtonEnabled => _continueButtonEnabled;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  List<SpannableGridCellData> get formFields => [
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

  late final TextEditingController genderController;
  late final TextEditingController lastNameController;
  late final TextEditingController firstNameController;
  late final TextEditingController dobController;
  late final TextEditingController homeTownController;
  late final TextEditingController idController;
  late final TextEditingController phoneController;
  late final TextEditingController parentPhoneController;
  late final TextEditingController mssvController;
  late final TextEditingController joinDateController;
  late final TextEditingController outDateController;
  late final TextEditingController notesController;

  SpannableGridCellData get lastNameField => SpannableGridCellData(
        id: 1,
        column: 1,
        row: 1,
        columnSpan: 4,
        child: AppFormField(
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_last_name,
          controller: lastNameController,
          required: true,
          keyboardType: TextInputType.name,
          maxLength: 30,
          prefixIcon: const Icon(FluentIcons.text_field_24_regular),
          enabled: isFormEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return appLocalizations!.app_form_field_required;
            }
          },
        ),
      );

  SpannableGridCellData get firstNameField => SpannableGridCellData(
        id: 2,
        column: 1,
        row: 2,
        columnSpan: 4,
        child: AppFormField(
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_first_name,
          controller: firstNameController,
          maxLength: 20,
          required: true,
          enabled: isFormEditing,
          prefixIcon: const Icon(FluentIcons.text_field_24_regular),
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return appLocalizations!.app_form_field_required;
            }
          },
        ),
      );

  SpannableGridCellData get genderField => SpannableGridCellData(
        id: 3,
        column: 1,
        row: 3,
        columnSpan: 4,
        child: AppFormField(
          type: AppFormFieldType.picker,
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_gender,
          controller: genderController,
          required: true,
          editable: false,
          enabled: isFormEditing,
          prefixIcon: const Icon(FluentIcons.people_24_regular),
          maxLength: 10,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return appLocalizations!.app_form_field_required;
            }
          },
          picker: AppFormPicker(
            type: AppFormPickerFieldType.custom,
            dataList: genderValues,
            onSelectedItemChanged: onGenderPickerSelectedIndexChanged,
          ),
        ),
      );

  SpannableGridCellData get dobField => SpannableGridCellData(
        id: 5,
        column: 1,
        row: 4,
        columnSpan: 4,
        child: AppFormField(
          type: AppFormFieldType.picker,
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_dob,
          controller: dobController,
          required: true,
          editable: false,
          enabled: isFormEditing,
          maxLength: 10,
          prefixIcon: const Icon(FluentIcons.food_cake_24_regular),
          picker: AppFormPicker(
            type: AppFormPickerFieldType.date,
            onSelectedItemChanged: onDateOfBirthPickerSelectedIndexChanged,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return appLocalizations!.app_form_field_required;
            }
          },
        ),
      );

  SpannableGridCellData get homeTownField => SpannableGridCellData(
        id: 6,
        column: 1,
        row: 5,
        columnSpan: 4,
        child: AppFormField(
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_hometown,
          controller: homeTownController,
          required: true,
          enabled: isFormEditing,
          maxLength: 100,
          prefixIcon: const Icon(FluentIcons.globe_24_regular),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return appLocalizations!.app_form_field_required;
            }
          },
        ),
      );

  SpannableGridCellData get idField => SpannableGridCellData(
        id: 7,
        column: 1,
        row: 6,
        columnSpan: 4,
        child: AppFormField(
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_id,
          controller: idController,
          required: true,
          enabled: isFormEditing,
          maxLength: 20,
          prefixIcon: const Icon(FluentIcons.phone_24_regular),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return appLocalizations!.app_form_field_required;
            }
          },
        ),
      );

  SpannableGridCellData get phoneField => SpannableGridCellData(
        id: 8,
        column: 1,
        row: 7,
        columnSpan: 4,
        child: AppFormField(
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_phone,
          controller: phoneController,
          required: true,
          enabled: student == null,
          maxLength: 10,
          prefixIcon: const Icon(FluentIcons.call_24_regular),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return appLocalizations!.app_form_field_required;
            }

            if (!value.isValidPhoneNumber) {
              return appLocalizations!.admin_manage_student_menu_add_validation_failed_phone_invalid;
            }
          },
        ),
      );

  SpannableGridCellData get parentPhoneField => SpannableGridCellData(
        id: 9,
        column: 1,
        row: 8,
        columnSpan: 4,
        child: AppFormField(
            context: context,
            label: appLocalizations!.admin_manage_student_menu_add_field_parent_phone,
            controller: parentPhoneController,
            enabled: isFormEditing,
            maxLength: 10,
            prefixIcon: const Icon(FluentIcons.call_transfer_20_regular),
            keyboardType: TextInputType.number,
            validator: (value) {
              if ((value != null && value.isNotEmpty) && !value.isValidPhoneNumber) {
                return appLocalizations!.admin_manage_student_menu_add_validation_failed_phone_invalid;
              }
            }),
      );

  SpannableGridCellData get mssvField => SpannableGridCellData(
        id: 10,
        column: 1,
        row: 9,
        columnSpan: 4,
        child: AppFormField(
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_mssv,
          controller: mssvController,
          maxLength: 15,
          enabled: isFormEditing,
          prefixIcon: const Icon(FluentIcons.hat_graduation_24_regular),
        ),
      );

  SpannableGridCellData get joinDateField => SpannableGridCellData(
        id: 11,
        column: 1,
        row: 10,
        columnSpan: 4,
        child: AppFormField(
          type: AppFormFieldType.picker,
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_join_date,
          controller: joinDateController,
          required: true,
          enabled: isFormEditing,
          editable: false,
          maxLength: 10,
          prefixIcon: const Icon(FluentIcons.calendar_arrow_down_24_regular),
          picker: AppFormPicker(
            type: AppFormPickerFieldType.date,
            onSelectedItemChanged: onJoinDatePickerSelectedIndexChanged,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return appLocalizations!.app_form_field_required;
            }
          },
        ),
      );

  SpannableGridCellData get outDateField => SpannableGridCellData(
        id: 12,
        column: 1,
        row: 11,
        columnSpan: 4,
        child: AppFormField(
          type: AppFormFieldType.picker,
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_out_date,
          controller: outDateController,
          enabled: isFormEditing,
          editable: false,
          maxLength: 10,
          prefixIcon: const Icon(FluentIcons.calendar_arrow_right_20_regular),
          picker: AppFormPicker(
            type: AppFormPickerFieldType.date,
            onSelectedItemChanged: onOutDatePickerSelectedIndexChanged,
          ),
        ),
      );

  SpannableGridCellData get notesField => SpannableGridCellData(
        id: 13,
        column: 1,
        row: 12,
        columnSpan: 4,
        child: AppFormField(
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_notes,
          controller: notesController,
          maxLength: 255,
          enabled: isFormEditing,
          prefixIcon: const Icon(FluentIcons.comment_24_regular),
        ),
      );

  /// Available gender names
  late final List<String> genderValues;

  /// Gender value
  String _gender = "";
  String get gender => _gender;
  void onGenderPickerSelectedIndexChanged(dynamic index) {
    _gender = genderValues[index];
    genderController.text = _gender;
    notifyListeners();
  }

  /// Date of Birth value
  DateTime? _dateOfBirth = DateTime(2000, 1, 1);
  DateTime? get dateOfBirth => _dateOfBirth;
  void onDateOfBirthPickerSelectedIndexChanged(dynamic date) {
    _dateOfBirth = date;
    dobController.text = date == null ? "" : getDateStringValue(date);
    notifyListeners();
  }

  /// join date value
  DateTime? _joinDate = DateTime(2000, 1, 1);
  DateTime? get joinDate => _joinDate;
  void onJoinDatePickerSelectedIndexChanged(dynamic date) {
    _joinDate = date;
    joinDateController.text = date == null ? "" : getDateStringValue(date);
    notifyListeners();
  }

  /// out date value
  DateTime? _outDate = DateTime(2000, 1, 1);
  DateTime? get outDate => _outDate;
  void onOutDatePickerSelectedIndexChanged(dynamic date) {
    _outDate = date;
    outDateController.text = date == null ? "" : getDateStringValue(date);
    notifyListeners();
  }

  String getDateStringValue(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  submit() async {
    if (formKey.currentState!.validate()) {
      // checking connectivity before process
      if (await hasConnectivity()) {
        _continueButtonEnabled = false;
        _isFormEditing = false;
        notifyListeners();

        // adding new Student
        if (student == null) {
          addNewStudent();
        } else {
          updateStudentInfo();
        }
      }
    } else {
      _continueButtonEnabled = false;
      notifyListeners();

      showSnackbar(
        appLocalizations!.app_form_validation_error,
        const Duration(seconds: 3),
        () {
          _continueButtonEnabled = true;
          notifyListeners();
        },
      );
    }
  }

  addNewStudent() {
    // check whether the given phone number is already registered
    AuthRepository.isPhoneNumberRegistered(
      phoneController.text.replaceFirst("0", "+84"),
    ).then((exists) {
      // the phonenumber is already registered => disallow adding
      if (exists) {
        showSnackbar(
            appLocalizations!.admin_manage_student_menu_add_validation_failed_phone_exists, const Duration(seconds: 3),
            () {
          _continueButtonEnabled = true;
          notifyListeners();
        });
      } else {
        // the phonenumber is not registered => allow adding
        // process adding new user
        showLoadingDialog();

        StudentRepository.setStudent(
          getFormData()..room = room.reference,
        ).catchError((onError) {
          showSnackbar(onError.toString(), const Duration(seconds: 5), () {
            _continueButtonEnabled = true;
            notifyListeners();
          });
        }).then((value) {
          showSnackbar(appLocalizations!.app_form_changes_saved, const Duration(seconds: 3), () {});
          // adding new student to this room successfully => return to the student list screen
          navigator.pop();
        }).whenComplete(() {
          _isFormEditing = true;
          notifyListeners();

          // when the future completed, hide the loading indicator
          navigator.pop();
        });
      }
    }).catchError((onError) {
      showSnackbar(onError, const Duration(seconds: 3), () {
        _continueButtonEnabled = true;
        notifyListeners();
      });
    }).whenComplete(() {
      _isFormEditing = true;
      notifyListeners();
    });
  }

  updateStudentInfo() {
    // process updating user info
    StudentRepository.setStudent(getFormData()..room = room.reference).catchError((onError) {
      showSnackbar(onError.toString(), const Duration(seconds: 5), () {});
    }).then((value) {
      showSnackbar(appLocalizations!.app_form_changes_saved, const Duration(seconds: 3), () {});
    }).whenComplete(() {
      _isFormEditing = true;
      _continueButtonEnabled = true;
      notifyListeners();
    });
  }

  Student getFormData() {
    return Student(
      id: phoneController.text.replaceFirst("0", "+84"),
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      isActive: true,
      gender: gender,
      hometown: homeTownController.text,
      birthDate: getDateStringValue(dateOfBirth!),
      joinDate: getDateStringValue(joinDate!),
      parentPhoneNumber: parentPhoneController.text,
      studentIdNumber: mssvController.text,
      citizenIdNumber: idController.text,
      notes: notesController.text,
    );
  }
}
