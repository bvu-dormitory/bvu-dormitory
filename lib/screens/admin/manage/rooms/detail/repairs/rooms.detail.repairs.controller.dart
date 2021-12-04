import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/item.dart';
import 'package:bvu_dormitory/models/repair_request.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/item.repository.dart';
import 'package:bvu_dormitory/repositories/repair_request.repository.dart';
import 'package:bvu_dormitory/widgets/app.form.field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:spannable_grid/spannable_grid.dart';

class AdminRoomsDetailRepairsController extends BaseController {
  AdminRoomsDetailRepairsController({
    required BuildContext context,
    required String title,
    required this.room,
  }) : super(context: context, title: title);

  final Room room;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  showRequestEditBottomSheet({RepairRequest? request}) {
    reasonController.text = request?.reason ?? "";
    notesController.text = request?.notes ?? "";

    showCupertinoModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withOpacity(0.75),
      backgroundColor: AppColor.secondaryBackgroundColor(context.read<AppController>().appThemeMode),
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
                    rows: request == null ? 3 : 4,
                    rowHeight: 100,
                    cells: [
                      SpannableGridCellData(
                        id: 1,
                        column: 1,
                        row: 1,
                        child: AppFormField(
                          label: appLocalizations!.admin_manage_rooms_detail_repair_reason,
                          maxLength: 30,
                          required: true,
                          context: context,
                          prefixIcon: const Icon(FluentIcons.text_change_case_24_regular),
                          type: AppFormFieldType.normal,
                          keyboardType: TextInputType.text,
                          controller: reasonController,
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
                        rowSpan: 2,
                        child: AppFormField(
                          label: appLocalizations!.admin_manage_rooms_detail_repair_notes,
                          maxLength: 100,
                          maxLines: 7,
                          required: false,
                          context: context,
                          // prefixIcon: const Icon(FluentIcons.text_change_case_24_regular),
                          type: AppFormFieldType.normal,
                          keyboardAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          controller: notesController,
                          validator: (value) {
                            // if (value == null || value.trim().isEmpty) {
                            //   return appLocalizations!.app_form_field_required;
                            // }
                          },
                        ),
                      ),
                      if (request != null) ...{
                        SpannableGridCellData(
                          id: 3,
                          column: 1,
                          row: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                appLocalizations!.admin_manage_rooms_detail_repair_done,
                                style: TextStyle(
                                  color: AppColor.textColor(this.context.read<AppController>().appThemeMode),
                                ),
                              ),
                              CupertinoSwitch(
                                value: request.done,
                                onChanged: (value) {
                                  _updateRequestState(request: request, value: value);
                                },
                              ),
                            ],
                          ),
                        ),
                      },
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (request != null) ...{
                    CupertinoButton(
                      // padding: const EdgeInsets.symmetric(horizontal: 40),
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(50),
                      child: const Icon(FluentIcons.delete_24_regular, color: Colors.red),
                      onPressed: () => deleteRequest(request),
                    ),
                  },
                  CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    borderRadius: BorderRadius.circular(50),
                    child: Text(
                        request == null ? appLocalizations!.app_form_add : appLocalizations!.app_form_save_changes),
                    onPressed: () => _handleFormSubmit(
                      formKey: formKey,
                      request: request,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  RepairRequest _getFormData() {
    return RepairRequest(
      timestamp: Timestamp.fromDate(DateTime.now()),
      reason: reasonController.text.trim(),
      room: room.reference!,
      notes: notesController.text.trim(),
    );
  }

  _handleFormSubmit({
    required GlobalKey<FormState> formKey,
    RepairRequest? request,
  }) async {
    if (formKey.currentState!.validate()) {
      if (await hasConnectivity()) {
        showLoadingDialog();

        try {
          if (request == null) {
            await RepairRequestRepository.addRequest(value: _getFormData());
          } else {
            await RepairRequestRepository.updateRequest(
              value: _getFormData()
                ..id = request.id
                ..done = request.done,
            );
          }
          navigator.pop();
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

  deleteRequest(RepairRequest theItem) async {
    if (await hasConnectivity()) {
      showLoadingDialog();

      try {
        await RepairRequestRepository.deleteRequest(theItem);
        navigator.pop();
      } catch (e) {
        navigator.pop();
        showSnackbar(e.toString(), const Duration(seconds: 5), () {});
      } finally {
        // turn off the loading indicator
        navigator.pop();
      }
    }
  }

  void _updateRequestState({required RepairRequest request, required bool value}) async {
    if (await hasConnectivity()) {
      showLoadingDialog();

      try {
        await RepairRequestRepository.updateRequest(value: request..done = value);
        navigator.pop();
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
