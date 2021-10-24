import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:spannable_grid/spannable_grid.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/students/add/students.add.controller.dart';

class AdminStudentsAddScreen extends BaseScreen<AdminStudentsAddController> {
  AdminStudentsAddScreen({
    Key? key,
    required String previousPageTitle,
  }) : super(key: key, previousPageTitle: previousPageTitle);

  @override
  AdminStudentsAddController provideController(BuildContext context) {
    return AdminStudentsAddController(
      context: context,
      title: AppLocalizations.of(context)?.admin_manage_student_menu_add ?? "admin_manage_student_menu_add",
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    final AdminStudentsAddController controller = context.read<AdminStudentsAddController>();

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
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Text(
            AppLocalizations.of(context)?.admin_manage_student_menu_add_guide ?? "admin_manage_student_menu_add_guide",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 30),
        SpannableGrid(
          // showGrid: true,
          columns: 4,
          rows: 8,
          spacing: 10.0,
          rowHeight: 100,
          cells: List.generate(
            controller.formFields.length,
            (index) {
              final field = controller.formFields[index];

              return SpannableGridCellData(
                id: field.label,
                column: field.colStart,
                row: field.rowStart,
                columnSpan: field.colSpan,
                child: _field(
                  action: index < controller.formFields.length - 1 ? TextInputAction.next : TextInputAction.done,
                  fieldController: field.controller,
                  editable: field.editable,
                  required: field.required,
                  type: field.type,
                  title: field.label,
                  onTap: field.onTap,
                  validator: field.validator,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: CupertinoButton.filled(
            child: Text(AppLocalizations.of(context)?.admin_manage_student_menu_add_submit ?? "admin_manage_student_menu_add_submit"),
            onPressed: context.read<AdminStudentsAddController>().submit,
          ),
        ),
      ],
    );
  }

  _field(
      {required TextEditingController fieldController,
      required String title,
      required TextInputType type,
      required TextInputAction action,
      bool required = false,
      bool editable = true,
      int maxLines = 1,
      String? Function(String?)? validator,
      void Function()? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (required) ...{
              const Text(
                "* ",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            },
            Text(
              title,
              style: const TextStyle(
                  // color: Colors.blueGrey,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: fieldController,
          onTap: onTap,
          readOnly: !editable,
          keyboardType: type,
          textInputAction: action,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.only(
              top: maxLines > 1 ? 15 : 0,
              bottom: 0,
              left: 15,
              right: 5,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(width: 2, color: Colors.blue.withOpacity(0.5)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(width: 2, color: Colors.red.withOpacity(0.5)),
            ),
          ),
        ),
      ],
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
                  AppLocalizations.of(context)?.app_dialog_action_cancel ?? "app_dialog_action_cancel",
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
                  AppLocalizations.of(context)?.app_dialog_action_ok ?? "app_dialog_action_ok",
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
              onSelectedItemChanged: controller.onGenderPickerSelectedIndexChanged,
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

  _datePicker({
    DateTime? initialValue,
    required Function(DateTime) onValueChanged,
    required Function() onDeleteButtonPressed,
  }) {
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
                onPressed: onDeleteButtonPressed,
                padding: EdgeInsets.zero,
                child: Text(
                  AppLocalizations.of(context)?.app_action_delete ?? "app_action_delete",
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
                  AppLocalizations.of(context)?.app_dialog_action_ok ?? "app_dialog_action_ok",
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
              initialDateTime: initialValue,
              onDateTimeChanged: onValueChanged,
              mode: CupertinoDatePickerMode.date,
            ),
          ),
        ],
      ),
    );
  }
}
