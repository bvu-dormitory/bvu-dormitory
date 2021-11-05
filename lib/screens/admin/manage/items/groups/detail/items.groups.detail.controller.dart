import 'dart:developer';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spannable_grid/spannable_grid.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bvu_dormitory/models/item.dart';
import 'package:bvu_dormitory/repositories/item.repository.dart';
import 'package:bvu_dormitory/widgets/app.form.field.dart';
import 'package:bvu_dormitory/widgets/app.form.picker.dart';

class AdminItemsGroupsDetailController extends BaseController {
  AdminItemsGroupsDetailController({
    required BuildContext context,
    required String title,
    required this.parentCategory,
    required this.parentGroup,
  }) : super(context: context, title: title);

  final ItemCategory parentCategory;
  final ItemGroup parentGroup;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final codeController = TextEditingController();
  final priceController = TextEditingController();
  final dateController = TextEditingController();
  final notesController = TextEditingController();

  showItemEditBottomSheet({Item? item}) {
    codeController.text = item?.code ?? "";
    priceController.text = item?.price ?? "";
    dateController.text = item?.purchaseDate ?? "";
    notesController.text = item?.notes ?? "";

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
                    rows: 4,
                    rowHeight: 110,
                    cells: [
                      SpannableGridCellData(
                        id: 1,
                        column: 1,
                        row: 1,
                        child: AppFormField(
                          label: appLocalizations!.admin_manage_item_detail_code,
                          maxLength: 30,
                          required: true,
                          context: context,
                          showSuffixCopyButton: true,
                          prefixIcon: const Icon(FluentIcons.text_change_case_24_regular),
                          type: AppFormFieldType.normal,
                          keyboardType: TextInputType.text,
                          controller: codeController,
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
                          label: appLocalizations!.admin_manage_item_detail_date,
                          maxLength: 30,
                          context: context,
                          required: true,
                          editable: false,
                          showSuffixCopyButton: true,
                          prefixIcon: const Icon(FluentIcons.person_24_regular),
                          type: AppFormFieldType.picker,
                          picker: AppFormPicker(
                              type: AppFormPickerFieldType.date,
                              onSelectedItemChanged: (value) {
                                if (value != null) {
                                  final theDate = value as DateTime;
                                  dateController.text = getDateStringValue(theDate);
                                } else {
                                  dateController.text = "";
                                }
                              }),
                          keyboardType: TextInputType.text,
                          controller: dateController,
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
                          label: appLocalizations!.admin_manage_item_detail_price,
                          maxLength: 30,
                          context: context,
                          showSuffixCopyButton: true,
                          prefixIcon: const Icon(CupertinoIcons.number, size: 20),
                          type: AppFormFieldType.normal,
                          keyboardType: TextInputType.text,
                          controller: priceController,
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              final parsedValue = int.tryParse(value);
                              if (parsedValue == null || parsedValue <= 0) {
                                return appLocalizations!.app_form_field_value_invalid;
                              }
                            }
                          },
                        ),
                      ),
                      SpannableGridCellData(
                        id: 4,
                        column: 1,
                        row: 4,
                        child: AppFormField(
                          label: appLocalizations!.admin_manage_item_detail_notes,
                          maxLength: 100,
                          context: context,
                          showSuffixCopyButton: true,
                          prefixIcon: const Icon(FluentIcons.note_24_regular, size: 20),
                          type: AppFormFieldType.normal,
                          keyboardType: TextInputType.text,
                          controller: notesController,
                          validator: (value) {},
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
                child: Text(item == null ? appLocalizations!.app_form_add : appLocalizations!.app_form_save_changes),
                onPressed: () => _handleFormSubmit(
                  formKey: formKey,
                  item: item,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String getDateStringValue(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  Item _getFormData() {
    return Item(
      code: codeController.text,
      price: priceController.text,
      purchaseDate: dateController.text,
      // inUse: false,
      notes: notesController.text,
    );
  }

  _handleFormSubmit({
    required GlobalKey<FormState> formKey,
    Item? item,
  }) async {
    if (formKey.currentState!.validate()) {
      if (await hasConnectivity()) {
        showLoadingDialog();

        final formData = _getFormData();

        try {
          // checking category existing
          final isItemCodeExists = await (item == null
              ? ItemRepository.isItemCodeAlreadyExists(
                  code: formData.code,
                  // categoryId: parentCategory.id!,
                  // groupId: parentGroup.id!,
                )
              : ItemRepository.isItemCodeAlreadyExistsExcept(
                  code: formData.code,
                  except: item.code,
                  // categoryId: parentCategory.id!,
                  // groupId: parentGroup.id!,
                ));

          if (isItemCodeExists) {
            navigator.pop();
            Future.delayed(const Duration(seconds: 0), () {
              showErrorDialog(appLocalizations!.admin_manage_item_category_already_exists);
            });
          } else {
            // no same item name existing, let's add a new/update
            if (item == null) {
              await ItemRepository.addItem(
                  value: formData, parentCategoryId: parentCategory.id!, parentGroupId: parentGroup.id!);
            } else {
              await ItemRepository.updateItem(
                  value: formData..id = item.id, parentCategoryId: parentCategory.id!, parentGroupId: parentGroup.id!);
              navigator.pop();
            }
            navigator.pop();
          }

          // if (item == null) {
          //   await ItemRepository.addItem(
          //       value: formData, parentCategoryId: parentCategory.id!, parentGroupId: parentGroup.id!);
          // } else {
          //   await ItemRepository.updateItem(
          //       value: formData..id = item.id, parentCategoryId: parentCategory.id!, parentGroupId: parentGroup.id!);
          //   navigator.pop();
          // }
          // navigator.pop();
        } catch (e) {
          print(e);
          // log(e.toString());

          navigator.pop();
          showSnackbar(e.toString(), const Duration(seconds: 10), () {});
        } finally {
          // turn off the loading indicator
          navigator.pop();
        }
      }
    }
  }

  // bottom sheet menu item
  onItemContextMenuOpen(Item item) {
    showBottomSheetMenuModal(item.code, null, true, [
      AppModalBottomSheetMenuGroup(items: [
        AppModalBottomSheetItem(
          label: Text(appLocalizations!.admin_manage_item_edit),
          icon: const Icon(FluentIcons.compose_24_regular),
          onPressed: () => showItemEditBottomSheet(item: item),
        ),
        AppModalBottomSheetItem(
          label: Text(appLocalizations!.admin_manage_item_detail_detach),
          icon: const Icon(CupertinoIcons.zoom_out),
          // onPressed: () => showItemEditBottomSheet(item: item),
        ),
        AppModalBottomSheetItem(
          label: Text(
            appLocalizations!.app_action_delete,
            style: const TextStyle(color: Colors.red),
          ),
          icon: const Icon(FluentIcons.delete_24_regular, color: Colors.red),
          onPressed: () => _deleteItem(item),
        ),
      ]),
    ]);
  }

  _deleteItem(Item item) async {
    if (await hasConnectivity()) {
      showLoadingDialog();

      try {
        // checking category existing
        await ItemRepository.deleteItem(
            id: item.id!, parentCategoryId: parentCategory.id!, parentGroupId: parentGroup.id!);
        navigator.pop();
      } catch (e) {
        showSnackbar(e.toString(), const Duration(seconds: 5), () {});
      } finally {
        navigator.pop();
      }
    }
  }

  // on item pressed => open detail page
  onItemPressed(ItemGroup group) {
    // navigator.push(
    //   CupertinoPageRoute(
    //     builder: (context) => AdminItemsGroupsDetailScreen(
    //       category: parentCategory,
    //       group: group,
    //       previousPageTitle: title,
    //     ),
    //   ),
    // );
  }
}
