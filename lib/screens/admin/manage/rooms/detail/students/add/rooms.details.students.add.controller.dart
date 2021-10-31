import 'dart:developer';

import 'package:bvu_dormitory/helpers/extensions/string.extensions.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/auth.repository.dart';
import 'package:bvu_dormitory/repositories/building.repository.dart';
import 'package:bvu_dormitory/repositories/room.repository.dart';
import 'package:bvu_dormitory/repositories/user.repository.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:flutter/services.dart';

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
  final bool enabled;
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
    this.enabled = true,
    this.formatters,
    this.onTap,
    this.pickerData,
    this.pickerType,
    this.pickerInitialData,
    this.onPickerSelectedItemChanged,
  });
}

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
    if (student != null) {
      log(student!.notes ?? "notes empty");

      genderController = TextEditingController(
        text: UserGender.values
            .firstWhere((element) => element.name == student!.gender, orElse: () => UserGender.male)
            .name,
      );
      lastNameController = TextEditingController(text: student!.lastName);
      firstNameController = TextEditingController(text: student!.firstName);
      dobController = TextEditingController(text: getDateStringValue(student!.birthDate));
      homeTownController = TextEditingController(text: student!.hometown);
      idController = TextEditingController(text: student!.citizenIdNumber);
      phoneController = TextEditingController(text: student!.phoneNumber!.replaceFirst("+84", "0"));
      parentPhoneController = TextEditingController(text: student!.parentPhoneNumber ?? "");
      mssvController = TextEditingController(text: student!.studentIdNumber ?? "");
      joinDateController = TextEditingController(text: getDateStringValue(student!.joinDate));
      outDateController =
          TextEditingController(text: student!.outDate != null ? getDateStringValue(student!.outDate!) : "");
      notesController = TextEditingController(text: student!.notes);
    } else {
      isViewing = false;
      isFormEditing = true;

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

  StudentProfileFormField get lastNameField => StudentProfileFormField(
        label: appLocalizations!.admin_manage_student_menu_add_field_last_name,
        controller: lastNameController,
        colStart: 1,
        rowStart: 1,
        colSpan: 4,
        required: true,
        type: TextInputType.name,
        maxLength: 30,
        icon: FluentIcons.text_field_24_regular,
        formatters: [],
        enabled: isFormEditing,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return appLocalizations!.admin_manage_student_menu_add_validation_failed_required;
          }
        },
      );

  StudentProfileFormField get firstNameField => StudentProfileFormField(
        label: appLocalizations!.admin_manage_student_menu_add_field_first_name,
        controller: firstNameController,
        colStart: 1,
        rowStart: 2,
        colSpan: 4,
        maxLength: 20,
        required: true,
        enabled: isFormEditing,
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
        rowStart: 3,
        colSpan: 4,
        required: true,
        editable: false,
        enabled: isFormEditing,
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
        colStart: 1,
        rowStart: 4,
        colSpan: 4,
        required: true,
        editable: false,
        enabled: isFormEditing,
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
        rowStart: 5,
        colSpan: 4,
        required: true,
        enabled: isFormEditing,
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
        rowStart: 6,
        colSpan: 4,
        required: true,
        enabled: isFormEditing,
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
        rowStart: 7,
        colSpan: 4,
        required: true,
        enabled: student == null,
        maxLength: 10,
        icon: FluentIcons.call_24_regular,
        type: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return appLocalizations!.admin_manage_student_menu_add_validation_failed_required;
          }

          if (!value.isValidPhoneNumber) {
            return appLocalizations!.admin_manage_student_menu_add_validation_failed_phone_invalid;
          }
        },
      );

  StudentProfileFormField get parentPhoneField => StudentProfileFormField(
      label: appLocalizations!.admin_manage_student_menu_add_field_parent_phone,
      controller: parentPhoneController,
      colStart: 1,
      rowStart: 8,
      colSpan: 4,
      enabled: isFormEditing,
      maxLength: 10,
      icon: FluentIcons.call_transfer_20_regular,
      type: TextInputType.number,
      validator: (value) {
        if ((value != null && value.isNotEmpty) && !value.isValidPhoneNumber) {
          return appLocalizations!.admin_manage_student_menu_add_validation_failed_phone_invalid;
        }
      });

  StudentProfileFormField get mssvField => StudentProfileFormField(
        label: appLocalizations!.admin_manage_student_menu_add_field_mssv,
        controller: mssvController,
        colStart: 1,
        rowStart: 9,
        colSpan: 4,
        maxLength: 15,
        enabled: isFormEditing,
        icon: FluentIcons.hat_graduation_24_regular,
      );

  StudentProfileFormField get joinDateField => StudentProfileFormField(
        label: appLocalizations!.admin_manage_student_menu_add_field_join_date,
        controller: joinDateController,
        colStart: 1,
        rowStart: 10,
        enabled: isFormEditing,
        colSpan: 4,
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
      colStart: 1,
      rowStart: 11,
      colSpan: 4,
      enabled: isFormEditing,
      editable: false,
      maxLength: 10,
      icon: FluentIcons.calendar_arrow_right_20_regular,
      pickerType: StudentFormFieldPickerType.date,
      onPickerSelectedItemChanged: onOutDatePickerSelectedIndexChanged);

  StudentProfileFormField get notesField => StudentProfileFormField(
        label: appLocalizations!.admin_manage_student_menu_add_field_notes,
        controller: notesController,
        colStart: 1,
        rowStart: 12,
        colSpan: 4,
        maxLength: 255,
        enabled: isFormEditing,
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

  submit() async {
    addNewStudent() {
      // check whether the given phone number is already registered
      AuthRepository.isPhoneNumberRegistered(
        phoneController.text.replaceFirst("0", "+84"),
      ).then((exists) {
        // the phonenumber is already registered => disallow adding
        if (exists) {
          showSnackbar(appLocalizations!.admin_manage_student_menu_add_validation_failed_phone_exists,
              const Duration(seconds: 3), () {
            _continueButtonEnabled = true;
            notifyListeners();
          });
        } else {
          // the phonenumber is not registered => allow adding
          // process adding new user
          showLoadingDialog();

          RoomRepository.addStudent(
            building.id!,
            floor.id!,
            room.id!,
            room.studentIdList ?? [],
            getFormData(),
          ).catchError((onError) {
            showSnackbar(onError.toString(), const Duration(seconds: 5), () {
              _continueButtonEnabled = true;
              notifyListeners();
            });
          }).then((value) {
            showSnackbar(appLocalizations!.admin_manage_student_menu_add_save_done, const Duration(seconds: 3), () {});
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
      UserRepository.addStudent(getFormData()).catchError((onError) {
        showSnackbar(onError.toString(), const Duration(seconds: 5), () {});
      }).then((value) {
        showSnackbar(appLocalizations!.admin_manage_student_menu_add_save_done, const Duration(seconds: 3), () {});
      }).whenComplete(() {
        _isFormEditing = true;
        _continueButtonEnabled = true;
        notifyListeners();
      });
    }

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
        appLocalizations!.admin_manage_student_menu_add_validation_failed,
        const Duration(seconds: 3),
        () {
          _continueButtonEnabled = true;
          notifyListeners();
        },
      );
    }
  }

  Student getFormData() {
    log('the gender: $gender');

    return Student(
      id: phoneController.text.replaceFirst("0", "+84"),
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      isActive: true,
      gender: gender,
      hometown: homeTownController.text,
      birthDate: dateOfBirth!,
      joinDate: joinDate!,
      parentPhoneNumber: parentPhoneController.text,
      studentIdNumber: mssvController.text,
      citizenIdNumber: idController.text,
      notes: notesController.text,
    );
  }
}
