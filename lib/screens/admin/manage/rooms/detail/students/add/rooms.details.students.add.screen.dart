import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:spannable_grid/spannable_grid.dart';

import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/base/base.controller.dart';

import 'rooms.details.students.add.controller.dart';

class AdminRoomsDetailStudentsAddScreen extends StatelessWidget {
  AdminRoomsDetailStudentsAddScreen({
    Key? key,
    required this.building,
    required this.floor,
    required this.room,
    this.student,
    required this.previousPageTitle,
  }) : super(key: key);

  String previousPageTitle;
  Building building;
  Floor floor;
  Room room;
  Student? student;

  @override
  Widget build(BuildContext context) {
    final controller = AdminRoomsDetailStudentsAddController(
      context: context,
      title: student == null
          ? AppLocalizations.of(context)!.admin_manage_student_menu_add
          : AppLocalizations.of(context)!.admin_manage_rooms_detail_students_view_profile,
      previousPageTitle: previousPageTitle,
      building: building,
      floor: floor,
      room: room,
      student: student,
    );

    return ChangeNotifierProvider.value(
      value: controller,
      child: const AdminRoomsDetailStudentsBody(),
    );
  }
}

class AdminRoomsDetailStudentsBody extends StatefulWidget {
  const AdminRoomsDetailStudentsBody({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminRoomsDetailStudentsBodyState();
}

class _AdminRoomsDetailStudentsBodyState extends State<AdminRoomsDetailStudentsBody> {
  late AdminRoomsDetailStudentsAddController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = context.watch<AdminRoomsDetailStudentsAddController>();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: _navigationBar(),
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: _body(),
      ),
    );
  }

  _navigationBar() {
    return CupertinoNavigationBar(
      middle: Text(controller.title),
      previousPageTitle: controller.previousPageTitle,
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Text(_getTrailingButtonTitle()),
        onPressed: controller.isViewing && !controller.isFormEditing
            ? () {
                controller.isFormEditing = true;
              }
            : controller.continueButtonEnabled
                ? controller.submit
                : null,
      ),
    );
  }

  String _getTrailingButtonTitle() {
    if (controller.isViewing) {
      if (!controller.isFormEditing) {
        return AppLocalizations.of(context)!.app_action_edit;
      } else {
        return AppLocalizations.of(context)!.app_form_save_changes;
      }
    }

    return AppLocalizations.of(context)!.app_form_continue;
  }

  _body() {
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
        // viewing is not necessary for asking
        if (!controller.isFormEditing || controller.student != null) {
          return Future.value(true);
        }

        if (!controller.isFormEmpty) {
          controller.showConfirmDialog(
            title: AppLocalizations.of(context)!.app_dialog_title_warning,
            body: Text(AppLocalizations.of(context)!.app_form_leaving_perform),
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
    final controller = context.watch<AdminRoomsDetailStudentsAddController>();

    return Column(
      // mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (controller.isFormEditing) ...{
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              AppLocalizations.of(context)!.app_form_guide,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
        },
        SpannableGrid(
          // showGrid: true,
          editingOnLongPress: false,
          columns: 4,
          rows: 12,
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
                  enabled: field.enabled,
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
    bool enabled = true,
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
    AppFormFieldPickerType? pickerType,
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
        Stack(
          children: [
            TextFormField(
              controller: fieldController,
              enabled: enabled,
              onTap: () {
                if (pickerType != null) {
                  if (pickerType == AppFormFieldPickerType.gender) {
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
              style: !enabled ? const TextStyle(color: Colors.grey) : null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.only(
                  top: maxLines > 1 ? 15 : 0,
                  bottom: 0,
                  left: 0,
                  right: 5,
                ),
                prefixIcon: icon != null ? Icon(icon) : null,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(0.5)),
                ),
                disabledBorder: OutlineInputBorder(
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
            Positioned(
              right: 0,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(Ionicons.ios_copy_outline),
                onPressed: () {
                  _copyFieldInfo(fieldController.text);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  _genderPicker(void Function(int) onPickerItemChanged) {
    final controller = context.read<AdminRoomsDetailStudentsAddController>();

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
    var value = null;

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
                onPressed: () {
                  Navigator.pop(context);
                  onPickerItemChange(value);
                },
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
              onDateTimeChanged: (val) {
                value = val;
              },
              mode: CupertinoDatePickerMode.date,
            ),
          ),
        ],
      ),
    );
  }

  _copyFieldInfo(String fieldValue) {
    FlutterClipboard.copy(fieldValue).then((value) {
      controller.showSnackbar(AppLocalizations.of(context)!.app_toast_copied, const Duration(seconds: 5), () {});
    }).catchError((onError) {
      controller.showSnackbar(onError.toString(), const Duration(seconds: 5), () {});
    });
  }
}
