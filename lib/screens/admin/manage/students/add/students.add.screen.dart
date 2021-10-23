import 'package:bvu_dormitory/app/constants/app.styles.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/students/add/students.add.controller.dart';
import 'package:spannable_grid/spannable_grid.dart';

class AdminStudentsAddScreen extends BaseScreen<AdminStudentsAddController> {
  AdminStudentsAddScreen({
    Key? key,
    required String previousPageTitle,
  }) : super(key: key, previousPageTitle: previousPageTitle);

  @override
  AdminStudentsAddController provideController(BuildContext context) {
    return AdminStudentsAddController(
      context: context,
      title: AppLocalizations.of(context)?.admin_manage_student_menu_add ??
          "admin_manage_student_menu_add",
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    final AdminStudentsAddController controller =
        context.read<AdminStudentsAddController>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Form(
            key: controller.formKey,
            child: _formFields(context),
          ),
        ),
      ),
    );
  }

  _formFields(BuildContext context) {
    final controller = context.watch<AdminStudentsAddController>();

    return Column(
      // mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SpannableGrid(
          columns: 3,
          rows: 4,
          spacing: 10.0,
          rowHeight: 100,
          cells: [
            SpannableGridCellData(
              id: 1,
              column: 1,
              row: 1,
              columnSpan: 2,
              child: _field(
                fieldController: controller.lastNameFieldController,
                editable: true,
                title: AppLocalizations.of(context)
                        ?.admin_manage_student_menu_add_field_last_name ??
                    "admin_manage_student_menu_add_field_last_name",
              ),
            ),
            SpannableGridCellData(
              id: 2,
              column: 3,
              row: 1,
              child: _field(
                fieldController: controller.firstNameFieldController,
                editable: true,
                title: AppLocalizations.of(context)
                        ?.admin_manage_student_menu_add_field_first_name ??
                    "admin_manage_student_menu_add_field_first_name",
              ),
            ),
            SpannableGridCellData(
              id: 4,
              column: 1,
              row: 2,
              columnSpan: 1,
              child: _field(
                fieldController: controller.genderFieldController,
                editable: false,
                title: AppLocalizations.of(context)
                        ?.admin_manage_student_menu_add_field_gender ??
                    "admin_manage_student_menu_add_field_gender",
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => _genderPicker(),
                  );
                },
              ),
            ),
            SpannableGridCellData(
              id: 5,
              column: 2,
              row: 2,
              columnSpan: 2,
              child: _field(
                fieldController: controller.dobFieldController,
                editable: false,
                title: AppLocalizations.of(context)
                        ?.admin_manage_student_menu_add_field_dob ??
                    "admin_manage_student_menu_add_field_dob",
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => _dateOfBirthPicker(),
                  );
                },
              ),
            ),
            SpannableGridCellData(
              id: 3,
              column: 1,
              row: 3,
              columnSpan: 3,
              child: _field(
                fieldController: controller.phoneFieldController,
                editable: true,
                title: AppLocalizations.of(context)
                        ?.admin_manage_student_menu_add_field_phone ??
                    "admin_manage_student_menu_add_field_phone",
              ),
            ),
            SpannableGridCellData(
              id: 6,
              column: 1,
              row: 4,
              columnSpan: 3,
              child: _field(
                fieldController: controller.homeTownFieldController,
                editable: true,
                title: AppLocalizations.of(context)
                        ?.admin_manage_student_menu_add_field_hometown ??
                    "admin_manage_student_menu_add_field_hometown",
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: CupertinoButton.filled(
            child: Text(AppLocalizations.of(context)
                    ?.admin_manage_student_menu_add_submit ??
                "admin_manage_student_menu_add_submit"),
            onPressed: context.read<AdminStudentsAddController>().submit,
          ),
        ),
      ],
    );
  }

  _field(
      {required TextEditingController fieldController,
      required String title,
      bool editable = true,
      void Function()? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
              // color: Colors.blueGrey,
              ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: fieldController,
          onTap: onTap,
          readOnly: !editable,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.only(
              top: 0,
              bottom: 0,
              left: 15,
              right: 5,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide:
                  BorderSide(width: 1, color: Colors.grey.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide:
                  BorderSide(width: 2, color: Colors.blue.withOpacity(0.5)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide:
                  BorderSide(width: 2, color: Colors.red.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }

  _dateOfBirthPicker() {
    final controller = context.read<AdminStudentsAddController>();

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
      height: 200,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                child: Text(
                  AppLocalizations.of(context)?.app_dialog_action_cancel ??
                      "app_dialog_action_cancel",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ),
              CupertinoButton(
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                child: Text(
                  AppLocalizations.of(context)?.app_dialog_action_ok ??
                      "app_dialog_action_ok",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: CupertinoDatePicker(
              initialDateTime: controller.dateOfBirth,
              onDateTimeChanged:
                  controller.ondateOfBirthPickerSelectedIndexChanged,
              mode: CupertinoDatePickerMode.date,
            ),
          ),
        ],
      ),
    );
  }

  _genderPicker() {
    final controller = context.read<AdminStudentsAddController>();

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
      height: 150,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                child: Text(
                  AppLocalizations.of(context)?.app_dialog_action_cancel ??
                      "app_dialog_action_cancel",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ),
              CupertinoButton(
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                child: Text(
                  AppLocalizations.of(context)?.app_dialog_action_ok ??
                      "app_dialog_action_ok",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 30,
              onSelectedItemChanged:
                  controller.onGenderPickerSelectedIndexChanged,
              children: List.generate(
                controller.genderValues.length,
                (index) => Text(controller.genderValues[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
