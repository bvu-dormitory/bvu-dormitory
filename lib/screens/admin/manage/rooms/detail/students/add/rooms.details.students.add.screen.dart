import 'package:bvu_dormitory/widgets/app.form.field.dart';
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
        backgroundColor: AppColor.backgroundColorLight,
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
        child: Scrollbar(
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
          cells: List.generate(controller.formFields.length, (index) => controller.formFields[index]),
        ),
      ],
    );
  }
}
