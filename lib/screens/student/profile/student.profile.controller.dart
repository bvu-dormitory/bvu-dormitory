import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/widgets/app.form.field.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:spannable_grid/spannable_grid.dart';

class StudentProfileDetailController extends BaseController {
  StudentProfileDetailController({
    required BuildContext context,
    required String title,
    required this.student,
  }) : super(context: context, title: title) {
    genderController = TextEditingController(
      text:
          UserGender.values.firstWhere((element) => element.name == student.gender, orElse: () => UserGender.male).name,
    );
    lastNameController = TextEditingController(text: student.lastName);
    firstNameController = TextEditingController(text: student.firstName);
    dobController = TextEditingController(text: student.birthDate);
    homeTownController = TextEditingController(text: student.hometown);
    idController = TextEditingController(text: student.citizenIdNumber);
    phoneController = TextEditingController(text: student.phoneNumber!.replaceFirst("+84", "0"));
    parentPhoneController = TextEditingController(text: student.parentPhoneNumber ?? "");
    mssvController = TextEditingController(text: student.studentIdNumber ?? "");
    joinDateController = TextEditingController(text: student.joinDate);
    notesController = TextEditingController(text: student.notes);
  }

  final Student student;

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
        notesField,
      ];

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
  late final TextEditingController notesController;

  SpannableGridCellData get lastNameField => SpannableGridCellData(
        id: 1,
        column: 1,
        row: 1,
        columnSpan: 4,
        child: AppFormField(
          showSuffixCopyButton: true,
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_last_name,
          controller: lastNameController,
          required: true,
          keyboardType: TextInputType.name,
          maxLength: 30,
          prefixIcon: const Icon(FluentIcons.text_field_24_regular),
          enabled: false,
        ),
      );

  SpannableGridCellData get firstNameField => SpannableGridCellData(
        id: 2,
        column: 1,
        row: 2,
        columnSpan: 4,
        child: AppFormField(
          showSuffixCopyButton: true,
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_first_name,
          controller: firstNameController,
          maxLength: 20,
          required: true,
          enabled: false,
          prefixIcon: const Icon(FluentIcons.text_field_24_regular),
          keyboardType: TextInputType.name,
        ),
      );

  SpannableGridCellData get genderField => SpannableGridCellData(
        id: 3,
        column: 1,
        row: 3,
        columnSpan: 4,
        child: AppFormField(
          showSuffixCopyButton: true,
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_gender,
          controller: genderController,
          required: true,
          editable: false,
          enabled: false,
          prefixIcon: const Icon(FluentIcons.people_24_regular),
          maxLength: 10,
        ),
      );

  SpannableGridCellData get dobField => SpannableGridCellData(
        id: 5,
        column: 1,
        row: 4,
        columnSpan: 4,
        child: AppFormField(
          showSuffixCopyButton: true,
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_dob,
          controller: dobController,
          required: true,
          editable: false,
          enabled: false,
          maxLength: 10,
          prefixIcon: const Icon(FluentIcons.food_cake_24_regular),
        ),
      );

  SpannableGridCellData get homeTownField => SpannableGridCellData(
        id: 6,
        column: 1,
        row: 5,
        columnSpan: 4,
        child: AppFormField(
          showSuffixCopyButton: true,
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_hometown,
          controller: homeTownController,
          required: true,
          enabled: false,
          maxLength: 100,
          prefixIcon: const Icon(FluentIcons.globe_24_regular),
        ),
      );

  SpannableGridCellData get idField => SpannableGridCellData(
        id: 7,
        column: 1,
        row: 6,
        columnSpan: 4,
        child: AppFormField(
          showSuffixCopyButton: true,
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_id,
          controller: idController,
          required: true,
          enabled: false,
          maxLength: 20,
          prefixIcon: const Icon(FluentIcons.phone_24_regular),
        ),
      );

  SpannableGridCellData get phoneField => SpannableGridCellData(
        id: 8,
        column: 1,
        row: 7,
        columnSpan: 4,
        child: AppFormField(
          showSuffixCopyButton: true,
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_phone,
          controller: phoneController,
          required: true,
          enabled: false,
          maxLength: 10,
          prefixIcon: const Icon(FluentIcons.call_24_regular),
          keyboardType: TextInputType.number,
        ),
      );

  SpannableGridCellData get parentPhoneField => SpannableGridCellData(
        id: 9,
        column: 1,
        row: 8,
        columnSpan: 4,
        child: AppFormField(
          showSuffixCopyButton: true,
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_parent_phone,
          controller: parentPhoneController,
          enabled: false,
          maxLength: 10,
          prefixIcon: const Icon(FluentIcons.call_transfer_20_regular),
          keyboardType: TextInputType.number,
        ),
      );

  SpannableGridCellData get mssvField => SpannableGridCellData(
        id: 10,
        column: 1,
        row: 9,
        columnSpan: 4,
        child: AppFormField(
          showSuffixCopyButton: true,
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_mssv,
          controller: mssvController,
          maxLength: 15,
          enabled: false,
          prefixIcon: const Icon(FluentIcons.hat_graduation_24_regular),
        ),
      );

  SpannableGridCellData get joinDateField => SpannableGridCellData(
        id: 11,
        column: 1,
        row: 10,
        columnSpan: 4,
        child: AppFormField(
          showSuffixCopyButton: true,
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_join_date,
          controller: joinDateController,
          required: true,
          enabled: false,
          editable: false,
          maxLength: 10,
          prefixIcon: const Icon(FluentIcons.calendar_arrow_down_24_regular),
        ),
      );

  SpannableGridCellData get notesField => SpannableGridCellData(
        id: 13,
        column: 1,
        row: 11,
        columnSpan: 4,
        child: AppFormField(
          showSuffixCopyButton: true,
          context: context,
          label: appLocalizations!.admin_manage_student_menu_add_field_notes,
          controller: notesController,
          maxLength: 255,
          enabled: false,
          prefixIcon: const Icon(FluentIcons.comment_24_regular),
        ),
      );
}
