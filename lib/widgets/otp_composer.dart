import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class OTPComposer extends StatefulWidget {
  Function(bool isValid, String? value) onChange;

  OTPComposer({Key? key, required this.onChange}) : super(key: key);

  @override
  _OTPComposerState createState() => _OTPComposerState();
}

class _OTPComposerState extends State<OTPComposer> {
  // var otpValueController = StreamController<int>();
  var otpDigits = List.filled(6, -1);

  List<TextEditingController> fieldControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    super.initState();

    // otpValueController
  }

  /// Check whether any digit is not in range [0-9]
  bool get isOtpValid {
    return !otpDigits.any((element) => element < 0 || element > 9);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        focusNodes.length,
        (index) {
          return field(index);
        },
      ),
    );
  }

  Container field(int fieldIndex) {
    return Container(
      width: 40,
      height: 40,
      child: TextField(
        autofocus: fieldIndex == 0,
        maxLength: 1,
        focusNode: focusNodes[fieldIndex],
        controller: fieldControllers[fieldIndex],
        onChanged: (value) {
          if (value != "") {
            // new value entered
            otpDigits[fieldIndex] = int.tryParse(value) ?? -1;
            FocusScope.of(context).requestFocus(
                focusNodes[fieldIndex < 5 ? fieldIndex + 1 : fieldIndex]);
          } else {
            // deleting
            otpDigits[fieldIndex] = -1;
            FocusScope.of(context)
                .requestFocus(focusNodes[fieldIndex > 0 ? fieldIndex - 1 : 0]);

            // auto select all content in the previous field
            var previousController =
                fieldControllers[fieldIndex > 0 ? fieldIndex - 1 : 0];
            previousController.selection = TextSelection(
                baseOffset: 0, extentOffset: previousController.text.length);
          }

          // notify to parent
          widget.onChange(isOtpValid, isOtpValid ? otpDigits.join('') : null);
        },
        textInputAction:
            fieldIndex < 5 ? TextInputAction.next : TextInputAction.done,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        ],
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        decoration: const InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.all(0),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
