import 'dart:developer';

import 'package:bvu_dormitory/helpers/extensions/string.extensions.dart';
import 'package:bvu_dormitory/screens/shared/login/login.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatefulWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  late LoginController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<LoginController>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: controller.loginInProcess
          ? const CupertinoActivityIndicator(
              radius: 10,
            )
          : Text(AppLocalizations.of(context)?.login_button_title ?? "login_button_title",
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue.shade800,
                fontWeight: FontWeight.bold,
              )),
      padding: EdgeInsets.symmetric(
        horizontal: controller.loginInProcess ? 15 : 20,
        vertical: controller.loginInProcess ? 15 : 15,
      ),
      color: Colors.yellowAccent.shade700,
      // disabledColor: Colors.yellowAccent.shade700,
      alignment: Alignment.centerRight,
      borderRadius: BorderRadius.circular(50),
      onPressed: controller.loginButtonEnabled == false ? null : handleLoginClick,
    );
  }

  handleLoginClick() {
    if (!controller.phoneInputController.text.isValidPhoneNumber) {
      controller.showErrorDialog(controller.appLocalizations?.login_error_phone_invalid_format ?? "login_error_phone_invalid_format");
      return;
    }

    controller.beforeVerifyPhoneNumber();
    Future.delayed(const Duration(seconds: 0), () {
      controller.verifyPhoneNumber().then((value) {}).catchError((onError) {
        log('error from button...');
      });
    });
  } // handleLoginClick
}
