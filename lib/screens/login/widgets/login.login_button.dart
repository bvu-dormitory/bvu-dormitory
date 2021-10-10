import 'dart:developer';

import 'package:bvu_dormitory/helpers/extensions/string.extensions.dart';
import 'package:bvu_dormitory/screens/login/login.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatefulWidget {
  LoginButton({Key? key}) : super(key: key);

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton>
    with SingleTickerProviderStateMixin {
  // animation
  late AnimationController animationController;
  late Animation animation;
  late AuthController controller;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    animation = Tween<double>(begin: 20.0, end: 15.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        print(status);
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<AuthController>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    log('rebuild login button...');
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => CupertinoButton(
        child: controller.loginInProcess
            ? const CupertinoActivityIndicator(
                radius: 10,
              )
            : Text(
                AppLocalizations.of(context)?.login_button_title ??
                    "login_button_title",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.bold,
                )),
        padding: EdgeInsets.symmetric(
          horizontal: animation.value,
          vertical: controller.loginInProcess ? 15 : 15,
        ),
        color: Colors.yellowAccent.shade700,
        // disabledColor: Colors.yellowAccent.shade700,
        alignment: Alignment.centerRight,
        borderRadius: BorderRadius.circular(50),
        onPressed:
            controller.loginButtonEnabled == false ? null : handleLoginClick,
      ),
    );
  }

  handleLoginClick() {
    if (!controller.phoneInputController.text.isValidPhoneNumber) {
      controller.showErrorDialog(
          controller.appLocalizations?.login_error_phone_invalid_format ??
              "login_error_phone_invalid_format");
      return;
    }

    // disable the Login button and start animating
    controller.beforeVerifyPhoneNumber();
    animationController.forward();

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          controller.verifyPhoneNumber().then((value) {
            animationController.reverse();
            animationController.removeStatusListener((status) => {});
          }).catchError((onError) {
            print('error from button...');
          });
        });
      }
    });
  } // handleLoginClick
}
