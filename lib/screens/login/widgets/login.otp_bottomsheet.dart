import 'dart:developer';

import 'package:bvu_dormitory/screens/login/login.controller.dart';
import 'package:bvu_dormitory/widgets/otp_composer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginOTPBottomSheet extends StatefulWidget {
  LoginOTPBottomSheet({Key? key}) : super(key: key);

  @override
  _LoginOTPBottomSheetState createState() => _LoginOTPBottomSheetState();
}

class _LoginOTPBottomSheetState extends State<LoginOTPBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  // late Animation animation;

  // @override
  // void initState() {
  //   super.initState();

  //   animationController = AnimationController(vsync: this);
  //   animation = Tween<double>(begin: -50, end: 20).animate(animationController)
  //     ..addStatusListener((status) {
  //       print(status);
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (context, controller, child) => AnimatedPositioned(
        bottom: controller.isOtpCodeSent ? 0 : -400,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeInOut,
        child: Container(
          height: 350,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, -5),
                blurRadius: 30,
              )
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)
                                ?.login_otp_bottom_sheet_title ??
                            "login_otp_bottom_sheet_title",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      // StreamBuilder(
                      //   initialData: '05:00',
                      //   stream: controller.remainingTime.stream,
                      //   builder: (context, snapshot) {
                      //     return Text(
                      //       snapshot.data.toString(),
                      //       style: const TextStyle(
                      //         color: Colors.red,
                      //       ),
                      //     );
                      //   },
                      // )
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    AppLocalizations.of(context)
                            ?.login_otp_bottom_sheet_guide_title(
                                controller.phoneInputController.text) ??
                        "login_otp_bottom_sheet_guide_title",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      // color: Colors.lightBlue,
                      // fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              OTPComposer(
                onChange: (isValid, value) {
                  controller.changeOTPComposingState(isValid, value);
                  // log('otp valid: $value');
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text(
                      AppLocalizations.of(context)
                              ?.login_otp_bottom_sheet_cancel_button ??
                          "login_otp_bottom_sheet_cancel_button",
                      style: const TextStyle(
                        color: Colors.red,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    // color: Colors.red,
                    disabledColor: Colors.blue.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(50),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      controller.hideOTPBottomSheet();
                    },
                  ),
                  CupertinoButton(
                    child: Text(
                      AppLocalizations.of(context)
                              ?.login_otp_bottom_sheet_submit_button ??
                          "login_otp_bottom_sheet_submit_button",
                      style: const TextStyle(
                          // fontWeight: FontWeight.bold,
                          ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    color: Colors.blue,
                    disabledColor: Colors.blue.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(50),
                    onPressed: (controller.isOtpPassed &&
                            !controller.otpVerifyInProcess)
                        ? controller.verifyOTP
                        : null,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
