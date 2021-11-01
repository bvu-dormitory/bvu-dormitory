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
  final dynamic initialValue;
  final void Function(dynamic) onSelectedItemChanged; // callback for parent
  dynamic currentValue;

  AppFormPicker({
    Key? key,
    this.dataList,
    this.initialValue,
    required this.type,
    required this.onSelectedItemChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AppFormPickerFieldType.date:

      default:
        return _datePicker(context);
    }
  }

  _datePicker(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
      height: 200,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// delete value button
              CupertinoButton(
                onPressed: () {
                  onSelectedItemChanged(null);
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

              /// ok button
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
          const SizedBox(height: 20),
          Expanded(
            child: CupertinoDatePicker(
              initialDateTime: initialValue,
              onDateTimeChanged: (value) {
                currentValue = value;
              },
              mode: CupertinoDatePickerMode.date,
            ),
          ),
        ],
      ),
    );
  }
}
