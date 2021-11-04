import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:spannable_grid/spannable_grid.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/item.dart';
import 'package:bvu_dormitory/repositories/item.repository.dart';
import 'package:bvu_dormitory/widgets/app.form.field.dart';

import 'groups/items.groups.screen.dart';

class AdminItemsController extends BaseController {
  AdminItemsController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showCategoryEditBottomSheet({ItemCategory? category}) {
    final nameController = TextEditingController(text: category == null ? "" : category.name);

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
                    rows: 1,
                    rowHeight: 100,
                    cells: [
                      SpannableGridCellData(
                        id: 1,
                        column: 1,
                        row: 1,
                        child: AppFormField(
                          label: appLocalizations!.admin_manage_item_category_name,
                          maxLength: 30,
                          required: true,
                          context: context,
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                borderRadius: BorderRadius.circular(50),
                child:
                    Text(category == null ? appLocalizations!.app_form_add : appLocalizations!.app_form_save_changes),
                onPressed: () => _handleFormSubmit(
                  formKey: formKey,
                  value: nameController.text.trim(),
                  category: category,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _handleFormSubmit({
    required GlobalKey<FormState> formKey,
    required String value,
    ItemCategory? category,
  }) async {
    log(category?.name ?? 'no categories');

    if (formKey.currentState!.validate()) {
      if (await hasConnectivity()) {
        showLoadingDialog();

        try {
          // checking category existing
          final isCategoryExists = await (category == null
              ? ItemRepository.isCategoryNameAlreadyExists(
                  value: value,
                )
              : ItemRepository.isCategoryNameAlreadyExistsExcept(
                  value: value,
                  except: category.name,
                ));

          if (isCategoryExists) {
            navigator.pop();
            Future.delayed(const Duration(seconds: 0), () {
              showErrorDialog(appLocalizations!.admin_manage_item_category_already_exists);
            });
          } else {
            // no same item name existing, let's add a new/update
            if (category == null) {
              await ItemRepository.addCategory(value: value);
            } else {
              await ItemRepository.updateCategory(value: value, categoryId: category.id!);
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
  onCategoryItemContextMenuOpen(ItemCategory category) {
    showBottomSheetMenuModal(category.name, null, true, [
      AppModalBottomSheetMenuGroup(items: [
        AppModalBottomSheetItem(
          label: Text(appLocalizations!.admin_manage_item_edit),
          icon: const Icon(FluentIcons.compose_24_regular),
          onPressed: () => showCategoryEditBottomSheet(category: category),
        ),
        AppModalBottomSheetItem(
          label: Text(
            appLocalizations!.app_action_delete,
            style: const TextStyle(color: Colors.red),
          ),
          icon: const Icon(FluentIcons.delete_24_regular, color: Colors.red),
          onPressed: () => _deleteCategory(category),
        ),
      ]),
    ]);
  }

  _deleteCategory(ItemCategory category) async {
    if (await hasConnectivity()) {
      showLoadingDialog();

      try {
        // checking category existing
        await ItemRepository.deleteCategory(id: category.id!);
        navigator.pop();
      } catch (e) {
        showSnackbar(e.toString(), const Duration(seconds: 5), () {});
      } finally {
        navigator.pop();
      }
    }
  }

  // on item pressed => open detail page
  onCategoryItemPressed(ItemCategory category) {
    navigator.push(
      CupertinoPageRoute(
          builder: (context) => AdminItemsGroupsScreen(parentCategory: category, previousPageTitle: title)),
    );
  }
}
