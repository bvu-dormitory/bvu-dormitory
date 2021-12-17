import 'dart:developer';

import 'package:bvu_dormitory/widgets/app.form.picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/service.dart';
import 'package:bvu_dormitory/repositories/service.repository.dart';
import 'package:bvu_dormitory/widgets/app.form.field.dart';

class AdminServicesAddController extends BaseController {
  AdminServicesAddController({
    required BuildContext context,
    required String title,
    this.service,
  }) : super(context: context, title: title) {
    if (service != null) {
      nameController = TextEditingController(text: service!.name);
      priceController = TextEditingController(text: service!.price.toString());
      unitController = TextEditingController(text: service!.unit);
      typeController = TextEditingController(text: service!.type.name);
    } else {
      nameController = TextEditingController();
      priceController = TextEditingController();
      unitController = TextEditingController();
      typeController = TextEditingController();
    }
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Service? service;

  List<AppFormField> get formFields => [
        nameField,
        priceField,
        unitField,
        typeField,
      ];

  bool get isFormEmpty => formControllers.every((element) => element.text.isEmpty);
  List<TextEditingController> get formControllers => [
        nameController,
        priceController,
        unitController,
        typeController,
      ];

  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController unitController;
  late final TextEditingController typeController;

  AppFormField get nameField => AppFormField(
        label: appLocalizations!.admin_manage_service_name,
        maxLength: 20,
        required: true,
        context: context,
        type: AppFormFieldType.normal,
        keyboardType: TextInputType.name,
        controller: nameController,
        prefixIcon: const Icon(FluentIcons.text_field_24_regular),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return appLocalizations!.app_form_field_required;
          }
        },
      );
  AppFormField get priceField => AppFormField(
        label: appLocalizations!.admin_manage_service_price,
        maxLength: 20,
        required: true,
        context: context,
        type: AppFormFieldType.normal,
        keyboardType: TextInputType.number,
        controller: priceController,
        prefixIcon: const Icon(CupertinoIcons.number, size: 20),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return appLocalizations!.app_form_field_required;
          }

          int? parsedValue = int.tryParse(value);
          if (parsedValue == null || parsedValue <= 0) {
            return appLocalizations!.app_form_field_value_invalid;
          }
        },
      );
  AppFormField get unitField => AppFormField(
        label: appLocalizations!.admin_manage_service_unit,
        maxLength: 20,
        required: true,
        context: context,
        type: AppFormFieldType.normal,
        keyboardType: TextInputType.name,
        controller: unitController,
        prefixIcon: const Icon(FluentIcons.ruler_24_regular),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return appLocalizations!.app_form_field_required;
          }
        },
      );
  AppFormField get typeField => AppFormField(
        label: appLocalizations!.admin_manage_service_type,
        maxLength: 20,
        required: true,
        context: context,
        type: AppFormFieldType.picker,
        picker: AppFormPicker(
          type: AppFormPickerFieldType.custom,
          dataList: ServiceType.values.map((e) => e.name).toList(),
          onSelectedItemChanged: (value) {
            typeController.text = value == null ? "" : ServiceType.values[value].name;
          },
        ),
        keyboardType: TextInputType.text,
        controller: typeController,
        prefixIcon: const Icon(FluentIcons.ruler_24_regular),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return appLocalizations!.app_form_field_required;
          }
        },
      );

  Service getFormValue() {
    return Service(
      name: nameController.text.trim(),
      price: int.parse(priceController.text),
      unit: unitController.text.trim(),
      type: ServiceType.values.firstWhere(
        (element) => element.name == typeController.text.trim(),
        orElse: () => ServiceType.seperated,
      ),
    );
  }

  submit() async {
    if (formKey.currentState!.validate()) {
      if (await hasConnectivity()) {
        // begin adding new service
        showLoadingDialog();

        try {
          // adding new service
          if (service == null) {
            final isServiceAlrealdyExists = await ServiceRepository.isServiceAlrealdyExists(nameController.text);

            if (!isServiceAlrealdyExists) {
              await ServiceRepository.setService(getFormValue());
              showSnackbar(appLocalizations!.admin_manage_service_service_added, const Duration(seconds: 3), () {});
              navigator.pop();
            } else {
              showSnackbar(
                  appLocalizations!.admin_manage_service_service_already_exists, const Duration(seconds: 3), () {});
            }
          }
          // editing old service
          else {
            final isServiceAlrealdyExists =
                await ServiceRepository.isServiceAlrealdyExistsExcept(nameController.text, service!.name);

            if (!isServiceAlrealdyExists) {
              await ServiceRepository.setService(getFormValue()..id = service!.id);
              showSnackbar(appLocalizations!.admin_manage_service_service_editted, const Duration(seconds: 3), () {});
              navigator.pop();
            } else {
              showSnackbar(
                  appLocalizations!.admin_manage_service_service_already_exists, const Duration(seconds: 3), () {});
            }
          }
        } catch (e) {
          showSnackbar(e.toString(), const Duration(seconds: 3), () {});
        } finally {
          navigator.pop();
        }
      }

      return;
    }

    // form data not yet valid
    showSnackbar(
      appLocalizations!.app_form_validation_error,
      const Duration(seconds: 3),
      () {},
    );
  }
}
