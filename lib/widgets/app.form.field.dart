import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:clipboard/clipboard.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'app.form.picker.dart';

enum AppFormFieldType {
  normal,
  picker,
}

class AppFormField extends StatelessWidget {
  AppFormField({
    Key? key,
    required this.label,
    required this.maxLength,
    required this.context,
    required this.controller,
    this.type = AppFormFieldType.normal,
    this.keyboardType = TextInputType.text,
    this.keyboardAction = TextInputAction.next,
    this.showSuffixCopyButton = false,
    this.enabled = true,
    this.required = false,
    this.editable = true,
    this.maxLines = 1,
    this.prefixIcon,
    this.formatters,
    this.validator,
    this.picker,
    this.errorText,
  }) : super(key: key) {
    // ensure if the field is a picker => the picker field must be passed in
    if (type == AppFormFieldType.picker) {
      assert(picker != null);
    }
  }

  final String label;
  final int maxLength;
  final BuildContext context;
  final AppFormFieldType type;
  final TextInputType keyboardType;
  final TextInputAction keyboardAction;
  final TextEditingController controller;
  final bool enabled;
  final bool required;
  final bool editable;
  final int maxLines;
  final bool showSuffixCopyButton;
  final Icon? prefixIcon;
  final List<TextInputFormatter>? formatters;
  final String? Function(String?)? validator;
  final AppFormPicker? picker;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.blueGrey,
                // fontWeight: FontWeight.w500,
              ),
            ),
            if (required) ...{
              const SizedBox(width: 5),
              const Icon(FluentIcons.star_24_filled, size: 7, color: Colors.red),
            },
          ],
        ),
        const SizedBox(height: 5),
        Stack(
          children: [
            TextFormField(
              controller: controller,
              enabled: enabled,
              onTap: () {
                if (type == AppFormFieldType.picker) {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return picker!;
                    },
                  );
                }
              },
              readOnly: !editable,
              keyboardType: keyboardType,
              textInputAction: keyboardAction,
              maxLines: maxLines,
              maxLength: maxLength,
              validator: validator,
              inputFormatters: formatters,
              style: !enabled ? const TextStyle(color: Colors.grey) : null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.only(
                  top: maxLines > 1 ? 15 : 0,
                  bottom: 0,
                  left: 0,
                  right: 5,
                ),
                prefixIcon: prefixIcon,
                errorText: errorText,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(0.5)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(width: 2, color: Colors.blue.withOpacity(0.5)),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(width: 2, color: Colors.red.withOpacity(0.5)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(width: 2, color: Colors.orange.shade900.withOpacity(0.25)),
                ),
              ),
            ),
            // show the copy button
            if (showSuffixCopyButton) ...{
              Positioned(
                right: 0,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(Ionicons.ios_copy_outline),
                  onPressed: () {
                    _copyFieldInfo(controller.text);
                  },
                ),
              ),
            }
          ],
        ),
      ],
    );
  }

  Future _copyFieldInfo(String fieldValue) {
    return FlutterClipboard.copy(fieldValue);
  }
}
