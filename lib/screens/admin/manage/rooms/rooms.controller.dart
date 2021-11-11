import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spannable_grid/spannable_grid.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/room.repository.dart';
import 'package:bvu_dormitory/widgets/app.form.field.dart';

class AdminRoomsController extends BaseController {
  AdminRoomsController({
    required BuildContext context,
    required String title,
    required this.building,
    required this.floor,
    this.pickingRoom = false,
  }) : super(context: context, title: title);

  Building building;
  Floor floor;

  final bool pickingRoom;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  _showRoomEditModal({Room? room}) {
    final nameController = TextEditingController(text: room == null ? "" : room.name);

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
                child: Text(room == null ? appLocalizations!.app_form_add : appLocalizations!.app_form_save_changes),
                onPressed: () => _handleFormSubmit(
                  formKey: formKey,
                  value: nameController.text.trim(),
                  room: room,
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
    Room? room,
  }) async {
    if (formKey.currentState!.validate()) {
      if (await hasConnectivity()) {
        showLoadingDialog();

        try {
          // checking category existing
          final isCategoryExists = await (room == null
              ? RoomRepository.isRoomNameAlreadyExists(
                  value: value,
                )
              : RoomRepository.isRoomNameAlreadyExistsExcept(
                  value: value,
                  except: room.name,
                ));

          if (isCategoryExists) {
            navigator.pop();
            Future.delayed(const Duration(seconds: 0), () {
              showErrorDialog(appLocalizations!.admin_manage_item_category_already_exists);
            });
          } else {
            // no same item name existing, let's add a new/update
            if (room == null) {
              await RoomRepository.addRoom(value: value);
            } else {
              await RoomRepository.updateRoom(value: value, roomId: room.id!);
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

  onAddRoomButtonPressed() {
    // _showRoomEditModal();
  }
}
