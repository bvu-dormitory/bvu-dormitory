import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:spannable_grid/spannable_grid.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/base/base.controller.dart';
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
      title: AppLocalizations.of(context)!.admin_manage_student_menu_add,
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {
    final controller = context.read<AdminStudentsAddController>();

    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Text(AppLocalizations.of(context)!.admin_manage_student_menu_add_continue),
      onPressed: controller.continueButtonEnabled ? controller.submit : null,
    );
  }

  @override
  Widget body(BuildContext context) {
    final AdminStudentsAddController controller = context.watch<AdminStudentsAddController>();

    return WillPopScope(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: _formFields(context),
            ),
          ),
        ),
      ),
      onWillPop: () {
        if (!controller.isFormEmpty) {
          controller.showConfirmDialog(
            title: AppLocalizations.of(context)!.app_dialog_title_warning,
            body: Text(AppLocalizations.of(context)!.admin_manage_student_menu_add_warning_data),
            confirmType: DialogConfirmType.submit,
            onSubmit: () {
              controller.navigator.pop();
              controller.navigator.pop();
            },
            onDismiss: () {
              controller.navigator.pop();
            },
          );
        } else {
          controller.navigator.pop();
        }

        // prevent popping
        return Future.value(false);
      },
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
            AppLocalizations.of(context)!.admin_manage_student_menu_add_guide,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 30),
        SpannableGrid(
          // showGrid: true,
          columns: 4,
          rows: 9,
          spacing: 10.0,
          rowHeight: 115,
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
                  validator: field.validator,
                  formatters: field.formatters,
                  maxLength: field.maxLength,
                  icon: field.icon,
                  pickerType: field.pickerType,
                  pickerData: field.pickerData,
                  pickerInitialData: field.pickerInitialData,
                  onPickerItemChanged: field.onPickerSelectedItemChanged,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _field({
    required TextEditingController fieldController,
    required String title,
    required TextInputType type,
    required TextInputAction action,
    bool required = false,
    bool editable = true,
    int maxLines = 1,
    IconData? icon,
    List<TextInputFormatter>? formatters,
    String? Function(String?)? validator,
    required int maxLength,
    List? pickerData,
    dynamic pickerInitialData,
    void Function(dynamic)? onPickerItemChanged,
    StudentFormFieldPickerType? pickerType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.blueGrey,
                // fontWeight: FontWeight.w500,
              ),
            ),
            if (required) ...{
              const SizedBox(width: 5),
              const Icon(FluentIcons.star_24_filled, size: 7, color: Colors.red),
            },
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: fieldController,
          onTap: () {
            if (pickerType != null) {
              if (pickerType == StudentFormFieldPickerType.gender) {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return _genderPicker(onPickerItemChanged!);
                  },
                );
              } else {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return _datePicker(
                      initialValue: pickerInitialData,
                      onPickerItemChange: onPickerItemChanged!,
                    );
                  },
                );
              }
            }
          },
          readOnly: !editable,
          keyboardType: type,
          textInputAction: action,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          inputFormatters: formatters,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.only(
              top: maxLines > 1 ? 15 : 0,
              bottom: 0,
              left: 0,
              right: 5,
            ),
            errorText: null,
            prefixIcon: icon != null ? Icon(icon) : null,
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
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(width: 2, color: Colors.orange.shade900.withOpacity(0.25)),
            ),
          ),
        ),
      ],
    );
  }

  _genderPicker(void Function(int) onPickerItemChanged) {
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
                  AppLocalizations.of(context)!.app_dialog_action_cancel,
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
                  AppLocalizations.of(context)!.app_dialog_action_ok,
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
              onSelectedItemChanged: onPickerItemChanged,
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
    required void Function(dynamic) onPickerItemChange,
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
                onPressed: () {
                  onPickerItemChange(null);
                },
                padding: EdgeInsets.zero,
                child: Text(
                  AppLocalizations.of(context)!.app_action_delete,
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
                  AppLocalizations.of(context)!.app_dialog_action_ok,
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
              // initialDateTime: initialValue,
              onDateTimeChanged: onPickerItemChange,
              mode: CupertinoDatePickerMode.date,
            ),
          ),
        ],
      ),
    );
  }
}
