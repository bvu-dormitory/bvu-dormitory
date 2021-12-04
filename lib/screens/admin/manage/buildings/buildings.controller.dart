import 'dart:developer';

import 'package:bvu_dormitory/widgets/app.form.field.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/repositories/building.repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spannable_grid/spannable_grid.dart';

import 'search/buildings.search.screen.dart';

class AdminBuildingsController extends BaseController {
  AdminBuildingsController({
    required BuildContext context,
    required String title,
    this.pickingRoom = false,
  }) : super(context: context, title: title);

  final bool pickingRoom;
  late List<bool> expansionStates;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionsController = TextEditingController();

  void updateExpansionStateAt(int index, bool state) {
    expansionStates[index] = state;
    notifyListeners();
  }

  void search(String roomName) {
    navigator.push(MaterialPageRoute(
      builder: (context) => AdminBuildingsSearchScreen(previousPageTitle: title),
    ));
  }

  showBuildingEditBottomSheet({Building? building}) {
    nameController.text = building?.name ?? "";
    descriptionsController.text = building?.descriptions ?? "";

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
                color: Colors.transparent,
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SpannableGrid(
                    columns: 1,
                    rows: 2,
                    rowHeight: 100,
                    cells: [
                      SpannableGridCellData(
                        id: 1,
                        column: 1,
                        row: 1,
                        child: AppFormField(
                          label: appLocalizations!.admin_manage_buildings_add_title,
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
                      SpannableGridCellData(
                        id: 2,
                        column: 1,
                        row: 2,
                        child: AppFormField(
                          label: appLocalizations!.admin_manage_buildings_add_descriptions,
                          maxLength: 30,
                          required: true,
                          context: context,
                          prefixIcon: const Icon(FluentIcons.text_change_case_24_regular),
                          type: AppFormFieldType.normal,
                          keyboardType: TextInputType.text,
                          controller: descriptionsController,
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
                    Text(building == null ? appLocalizations!.app_form_add : appLocalizations!.app_form_save_changes),
                onPressed: () => _handleFormSubmit(
                  formKey: formKey,
                  building: building,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Building _getFormData() {
    return Building(
      name: nameController.text.trim(),
      descriptions: descriptionsController.text.trim(),
    );
  }

  _handleFormSubmit({
    required GlobalKey<FormState> formKey,
    Building? building,
  }) async {
    if (formKey.currentState!.validate()) {
      if (await hasConnectivity()) {
        showLoadingDialog();

        try {
          // checking category existing
          final isCategoryExists = await (building == null
              ? BuildingRepository.isBuildingNameAlreadyExists(
                  value: nameController.text.trim(),
                )
              : BuildingRepository.isBuildingNameAlreadyExistsExcept(
                  value: nameController.text.trim(),
                  except: building.name,
                ));

          if (isCategoryExists) {
            Future.delayed(const Duration(seconds: 0), () {
              showErrorDialog(appLocalizations!.admin_manage_buildings_add_error_existed);
            });
          } else {
            // no same item name existing, let's add a new/update
            if (building == null) {
              await BuildingRepository.addBuilding(value: _getFormData());
            } else {
              await BuildingRepository.updateBuilding(value: _getFormData()..id = building.id);
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

          notifyListeners();
        }
      }
    }
  }

  // void onFloorOrderChanged({required String buildingId, required int oldOrder, required int newOrder}) {
  //   BuildingRepository.changeFloorOrder(buildingId: buildingId, oldOrder: oldOrder, newOrder: newOrder);
  // }
}
