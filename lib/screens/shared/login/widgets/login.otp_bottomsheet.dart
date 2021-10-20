import 'package:bvu_dormitory/screens/shared/login/login.controller.dart';
import 'package:bvu_dormitory/widgets/otp_composer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginOTPBottomSheet extends StatefulWidget {
  const LoginOTPBottomSheet({Key? key}) : super(key: key);

  @override
  _LoginOTPBottomSheetState createState() => _LoginOTPBottomSheetState();
}

class _LoginOTPBottomSheetState extends State<LoginOTPBottomSheet> {
  late LoginController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<LoginController>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
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
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _header(),
            OTPComposer(
              disabled: controller.otpVerifyInProcess,
              onChange: (isValid, value) {
                controller.changeOTPComposingState(isValid, value);
                // log('otp valid: $value');
              },
            ),
            _footer(),
          ],
        ),
      ),
    );
  }

  _header() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)?.login_otp_bottom_sheet_title ??
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
          AppLocalizations.of(context)?.login_otp_bottom_sheet_guide_title(
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
    );
  }

  _footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CupertinoButton(
          child: Text(
            AppLocalizations.of(context)
                    ?.login_otp_bottom_sheet_cancel_button ??
                "login_otp_bottom_sheet_cancel_button",
            style: TextStyle(
              color: controller.otpVerifyInProcess ? Colors.grey : Colors.red,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          // color: Colors.red,
          // disabledColor: Colors.red.withOpacity(0.25),
          borderRadius: BorderRadius.circular(50),
          onPressed: controller.otpVerifyInProcess
              ? null
              : () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  controller.hideOTPBottomSheet();
                },
        ),
        CupertinoButton(
          child: controller.otpVerifyInProcess
              ? const CupertinoActivityIndicator(
                  radius: 10,
                )
              : Text(
                  AppLocalizations.of(context)
                          ?.login_otp_bottom_sheet_submit_button ??
                      "login_otp_bottom_sheet_submit_button",
                  style: const TextStyle(
                      // fontWeight: FontWeight.bold,
                      ),
                ),
          padding: controller.otpVerifyInProcess
              ? const EdgeInsets.all(5)
              : const EdgeInsets.symmetric(horizontal: 30),
          color: Colors.blue,
          disabledColor: Colors.blue.withOpacity(0.25),
          borderRadius: BorderRadius.circular(50),
          onPressed: controller.isOtpPassed && !controller.otpVerifyInProcess
              ? controller.verifyOTP
              : null,
        ),
      ],
    );
  }
}
