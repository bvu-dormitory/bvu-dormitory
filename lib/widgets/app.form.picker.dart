import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AppFormPickerFieldType {
  date,
  custom,
}

class AppFormPicker extends StatelessWidget {
  final AppFormPickerFieldType type;
  final List<dynamic>? dataList;
  final void Function(dynamic) onSelectedItemChanged; // callback for parent

  final bool required;
  final dynamic initialValue;
  dynamic currentValue;
  late CupertinoDatePicker datePicker;
  late CupertinoPicker customPicker;

  AppFormPicker({
    Key? key,
    this.dataList,
    this.initialValue,
    this.required = false,
    required this.type,
    required this.onSelectedItemChanged,
  }) : super(key: key) {
    /// date picker
    if (type == AppFormPickerFieldType.date) {
      currentValue = initialValue;

      datePicker = CupertinoDatePicker(
        initialDateTime: initialValue,
        onDateTimeChanged: (value) {
          currentValue = value;
        },
        mode: CupertinoDatePickerMode.date,
      );
    }

    /// custom picker
    else {
      customPicker = CupertinoPicker(
        itemExtent: 32,
        scrollController: FixedExtentScrollController(initialItem: dataList!.indexOf(initialValue)),
        onSelectedItemChanged: (value) {
          currentValue = value;
        },
        children: dataList!.map((e) => Text(e.toString())).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
      height: 300,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: !required ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
            children: [
              /// value removing button => clear current value
              if (!required) ...{
                CupertinoButton(
                  onPressed: () {
                    onSelectedItemChanged(null);
                    Navigator.of(context).pop();
                  },
                  padding: EdgeInsets.zero,
                  child: Text(
                    AppLocalizations.of(context)!.app_action_delete,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ),
              },

              /// ok button => return lastest selected value
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                  onSelectedItemChanged(currentValue);
                },
                padding: EdgeInsets.zero,
                child: Text(
                  AppLocalizations.of(context)!.app_dialog_action_ok,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          // const SizedBox(height: 20),
          Expanded(
            child: type == AppFormPickerFieldType.date ? datePicker : customPicker,
          ),
        ],
      ),
    );
  }
}
