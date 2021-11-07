import 'dart:developer';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/item.dart';
import 'package:bvu_dormitory/repositories/item.repository.dart';
import 'package:bvu_dormitory/widgets/app.form.field.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spannable_grid/spannable_grid.dart';

import 'detail/items.groups.detail.screen.dart';
import 'package:bvu_dormitory/helpers/extensions/string.extensions.dart';

class AdminItemsGroupsController extends BaseController {
  AdminItemsGroupsController({
    required BuildContext context,
    required String title,
    required this.parentCategory,
  }) : super(context: context, title: title);

  final ItemCategory parentCategory;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final providerNameController = TextEditingController();
  final providerPhoneController = TextEditingController();

  showGroupEditBottomSheet({ItemGroup? group}) {
    nameController.text = group?.name ?? "";
    providerNameController.text = group?.providerName ?? "";
    providerPhoneController.text = group?.providerPhone ?? "";

    showCupertinoModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SpannableGrid(
                    columns: 1,
                    rows: 3,
                    rowHeight: 110,
                    cells: [
                      SpannableGridCellData(
                        id: 1,
                        column: 1,
                        row: 1,
                        child: AppFormField(
                          label: appLocalizations!.admin_manage_item_provider_type,
                          maxLength: 30,
                          required: true,
                          context: context,
                          showSuffixCopyButton: true,
                          prefixIcon: const Icon(FluentIcons.text_change_case_24_regular),
                          type: AppFormFieldType.normal,
                          keyboardType: TextInputType.text,
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return appLocalizations!.app_form_field_required;
                            }
                          },
                        ),
                      ),
                      SpannableGridCellData(
                        id: 2,
                        column: 1,
                        row: 2,
                        child: AppFormField(
                          label: appLocalizations!.admin_manage_item_provder_name,
                          maxLength: 30,
                          context: context,
                          required: true,
                          showSuffixCopyButton: true,
                          prefixIcon: const Icon(FluentIcons.person_24_regular),
                          type: AppFormFieldType.normal,
                          keyboardType: TextInputType.text,
                          controller: providerNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return appLocalizations!.app_form_field_required;
                            }
                          },
                        ),
                      ),
                      SpannableGridCellData(
                        id: 3,
                        column: 1,
                        row: 3,
                        child: AppFormField(
                          label: appLocalizations!.admin_manage_item_provder_phone,
                          maxLength: 30,
                          context: context,
                          showSuffixCopyButton: true,
                          prefixIcon: const Icon(FluentIcons.call_24_regular),
                          type: AppFormFieldType.normal,
                          keyboardType: TextInputType.number,
                          controller: providerPhoneController,
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty && !value.isValidPhoneNumber) {
                              return appLocalizations!.login_error_phone_invalid_format;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                borderRadius: BorderRadius.circular(50),
                child: Text(group == null ? appLocalizations!.app_form_add : appLocalizations!.app_form_save_changes),
                onPressed: () => _handleFormSubmit(
                  formKey: formKey,
                  group: group,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ItemGroup _getFormData() {
    return ItemGroup(
      name: nameController.text,
      providerName: providerNameController.text,
      providerPhone: providerPhoneController.text,
    );
  }

  _handleFormSubmit({
    required GlobalKey<FormState> formKey,
    ItemGroup? group,
  }) async {
    if (formKey.currentState!.validate()) {
      if (await hasConnectivity()) {
        showLoadingDialog();

        final formData = _getFormData();

        try {
          // checking category existing
          final isGroupExists = await (group == null
              ? ItemRepository.isGroupNameAlreadyExists(value: formData.name, categoryId: parentCategory.id!)
              : ItemRepository.isGroupNameAlreadyExistsExcept(
                  value: formData.name,
                  except: group.name,
                  categoryId: parentCategory.id!,
                ));

          if (isGroupExists) {
            navigator.pop();
            Future.delayed(const Duration(seconds: 0), () {
              showErrorDialog(appLocalizations!.admin_manage_item_category_already_exists);
            });
          } else {
            // no same item name existing, let's add a new/update
            if (group == null) {
              await ItemRepository.addGroup(value: formData, parentCategoryId: parentCategory.id!);
            } else {
              await ItemRepository.updateGroup(value: formData..id = group.id, parentCategoryId: parentCategory.id!);
              navigator.pop();
            }
            navigator.pop();
          }
        } catch (e) {
          navigator.pop();
          showSnackbar(e.toString(), const Duration(seconds: 5), () {});
        } finally {
          // turn off the loading indicator
          navigator.pop();
        }
      }
    }
  }

  // bottom sheet menu item
  onGroupItemContextMenuOpen(ItemGroup category) {
    showBottomSheetMenuModal(category.name, null, true, [
      AppModalBottomSheetMenuGroup(items: [
        AppModalBottomSheetItem(
          label: Text(appLocalizations!.admin_manage_item_edit),
          icon: const Icon(FluentIcons.compose_24_regular),
          onPressed: () => showGroupEditBottomSheet(group: category),
        ),
        AppModalBottomSheetItem(
          label: Text(
            appLocalizations!.app_action_delete,
            style: const TextStyle(color: Colors.red),
          ),
          icon: const Icon(FluentIcons.delete_24_regular, color: Colors.red),
          onPressed: () => _deleteGroup(category),
        ),
      ]),
    ]);
  }

  _deleteGroup(ItemGroup category) async {
    if (await hasConnectivity()) {
      showLoadingDialog();

      try {
        // checking category existing
        await ItemRepository.deleteGroup(id: category.id!, parentCategoryId: parentCategory.id!);
        navigator.pop();
      } catch (e) {
        showSnackbar(e.toString(), const Duration(seconds: 5), () {});
      } finally {
        navigator.pop();
      }
    }
  }

  // on item pressed => open detail page
  onGroupItemPressed(ItemGroup group) {
    navigator.push(
      CupertinoPageRoute(
        builder: (context) => AdminItemsGroupsDetailScreen(
          category: parentCategory,
          group: group,
          previousPageTitle: title,
        ),
      ),
    );
  }
}
