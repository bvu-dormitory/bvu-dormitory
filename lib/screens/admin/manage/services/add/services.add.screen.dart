import 'dart:developer';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spannable_grid/spannable_grid.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'services.add.controller.dart';

class AdminServicesAddScreen extends BaseScreen<AdminServicesAddController> {
  AdminServicesAddScreen({
    Key? key,
    String? previousPageTitle,
    this.service,
  }) : super(key: key, previousPageTitle: previousPageTitle, haveNavigationBar: true);

  final Service? service;

  @override
  AdminServicesAddController provideController(BuildContext context) {
    return AdminServicesAddController(
      context: context,
      title: service == null
          ? AppLocalizations.of(context)!.admin_manage_service_add
          : AppLocalizations.of(context)!.admin_manage_service_edit,
      service: service,
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Text(AppLocalizations.of(context)!.app_form_continue),
      onPressed: context.read<AdminServicesAddController>().submit,
    );
  }

  @override
  Widget body(BuildContext context) {
    final controller = context.read<AdminServicesAddController>();

    return WillPopScope(
      onWillPop: () {
        if (controller.service != null) {
          return Future.value(true);
        }

        if (!controller.isFormEmpty) {
          controller.showConfirmDialog(
              title: controller.appLocalizations!.app_dialog_title_warning,
              body: Text(controller.appLocalizations!.app_form_leaving_perform),
              confirmType: DialogConfirmType.submit,
              onSubmit: () {
                controller.navigator.pop();
                controller.navigator.pop();
              });
          return Future.value(false);
        }

        return Future.value(true);
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  controller.appLocalizations!.app_form_guide,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Form(
                key: controller.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: _form(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _form() {
    final controller = context.read<AdminServicesAddController>();

    return SpannableGrid(
      // showGrid: true,
      editingOnLongPress: false,
      columns: 1,
      rows: 4,
      spacing: 10.0,
      rowHeight: 115,
      cells: List.generate(controller.formFields.length, (index) {
        final field = controller.formFields[index];
        return SpannableGridCellData(id: field.label, column: 1, row: index + 1, child: field);
      }),
    );
  }
}
