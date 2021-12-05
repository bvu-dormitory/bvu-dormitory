import 'dart:convert';
import 'dart:developer';

import 'package:bvu_dormitory/repositories/newsfeed.repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
// import 'package:flutter_quill/flutter_quill.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:spannable_grid/spannable_grid.dart';

import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/inform.dart';
import 'package:bvu_dormitory/widgets/app.form.field.dart';

class NewsFeedController extends BaseController {
  NewsFeedController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late QuillController contentController;

  void showInformModal({Inform? inform}) {
    titleController.text = inform?.title ?? "";

    if (inform != null) {
      contentController = QuillController(
        document: Document.fromJson(jsonDecode(inform.content)),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      contentController = QuillController.basic();
    }

    showCupertinoModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withOpacity(0.75),
      backgroundColor: AppColor.secondaryBackgroundColor(context.read<AppController>().appThemeMode),
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: SpannableGrid(
                      columns: 1,
                      rows: 4,
                      rowHeight: 120,
                      editingOnLongPress: false,
                      cells: [
                        SpannableGridCellData(
                          id: 1,
                          column: 1,
                          row: 1,
                          child: AppFormField(
                            label: appLocalizations!.newsfeed_title,
                            maxLength: 50,
                            required: true,
                            context: context,
                            prefixIcon: const Icon(FluentIcons.text_change_case_24_regular),
                            type: AppFormFieldType.normal,
                            keyboardType: TextInputType.text,
                            controller: titleController,
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
                          rowSpan: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              children: [
                                QuillToolbar.basic(
                                  controller: contentController,
                                  showHeaderStyle: false,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: QuillEditor.basic(
                                      controller: contentController,
                                      readOnly: false,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                borderRadius: BorderRadius.circular(50),
                child: Text(inform == null ? appLocalizations!.app_form_add : appLocalizations!.app_form_save_changes),
                onPressed: () => _handleFormSubmit(inform: inform),
              ),
            ],
          ),
        );
      },
    );
  }

  _handleFormSubmit({Inform? inform}) async {
    if (formKey.currentState!.validate()) {
      if (contentController.document.length == 1 || contentController.document.length > 500) {
        showErrorDialog(appLocalizations!.newsfeed_error_content_length);
        return;
      }

      final formData = Inform(
        title: titleController.text.trim(),
        content: jsonEncode(contentController.document.toDelta()),
        timestamp: Timestamp.fromDate(DateTime.now()),
      );

      try {
        if (inform == null) {
          await NewsFeedRepository.addInform(formData);
        } else {
          await NewsFeedRepository.updateInform(
            formData
              ..id = inform.id
              ..timestamp = inform.timestamp,
          );
          navigator.pop();
        }
      } catch (e) {
        showSnackbar(e.toString(), const Duration(seconds: 5), () {});
      } finally {
        navigator.pop();
      }
    }
  }

  onInformMenuButtonPressed(Inform inform) {
    showBottomSheetMenuModal(
      inform.title,
      null,
      true,
      [
        AppModalBottomSheetMenuGroup(items: [
          AppModalBottomSheetItem(
            label: appLocalizations!.app_action_edit,
            icon: const Icon(FluentIcons.compose_24_regular),
            onPressed: () {
              showInformModal(inform: inform);
            },
          ),
          AppModalBottomSheetItem(
            label: appLocalizations!.app_action_delete,
            labelStyle: const TextStyle(color: Colors.red),
            icon: const Icon(FluentIcons.delete_24_regular, color: Colors.red),
            onPressed: () {
              _deleteInform(inform: inform);
            },
          ),
        ]),
      ],
    );
  }

  void _deleteInform({required Inform inform}) async {
    try {
      await NewsFeedRepository.deleteInform(inform);
    } catch (e) {
      showSnackbar(e.toString(), const Duration(seconds: 5), () {});
    } finally {
      navigator.pop();
    }
  }
}
