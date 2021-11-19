import 'dart:async';

import 'package:bvu_dormitory/repositories/auth.repository.dart';
import 'package:bvu_dormitory/repositories/user.repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/app/app.logger.dart';
import 'package:bvu_dormitory/app/constants/app.routes.dart';

class LoginController extends BaseController {
  LoginController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  // native firebase auth params
  Duration otpTimeout = const Duration(seconds: 30);
  String? verificationId;
  String? otpCode;

  // the phone number text field's controller
  final TextEditingController _phoneInputController = TextEditingController();

  TextEditingController get phoneInputController => _phoneInputController;

  // toggle the login button
  bool _loginButtonEnabled = true;
  bool get loginButtonEnabled => _loginButtonEnabled;

  // toggle the login button and loading indicator
  bool _loginInProcess = false;
  bool get loginInProcess => _loginInProcess;

  // toggle the login button and loading indicator
  bool _otpVerifyInProcess = false;
  bool get otpVerifyInProcess => _otpVerifyInProcess;

  // toggle show/hide the otp_bottom_sheet's bottom coordinate (position)
  bool _isOtpCodeSent = false;
  bool get isOtpCodeSent => _isOtpCodeSent;

  // toggle the continuing button in the otp_botton_sheet
  bool _isOtpPassed = false;
  bool get isOtpPassed => _isOtpPassed;

  void showOTPBottomSheet() {
    _isOtpCodeSent = true;
    notifyListeners();
  }

  void hideOTPBottomSheet() {
    _isOtpCodeSent = false;
    _loginButtonEnabled = true;
    _loginInProcess = false;

    notifyListeners();
  }

  void changeOTPComposingState(bool passed, String? otpCode) {
    _isOtpPassed = passed;
    this.otpCode = otpCode ?? "";
    notifyListeners();
  }

  void beforeVerifyPhoneNumber() {
    _loginInProcess = true;
    _loginButtonEnabled = false;
    notifyListeners();
  }

  Future<void> verifyPhoneNumber() async {
    AuthRepository.instance.verifyPhoneNumber(
      phoneNumber: phoneInputController.text.replaceFirst('0', '+84'),
      timeout: otpTimeout,
      verificationCompleted: (phoneAuthCredential) {
        _loginInProcess = false;
        _loginButtonEnabled = true;
        notifyListeners();

        logger.i('verificationCompleted');
        return;
      },
      verificationFailed: (error) {
        logger.e('error authenticating phone..');
        logger.e(error);

        switch (error.code) {
          // user has tried to login so many times in a short period of time
          case 'too-many-requests':
            showErrorDialog(appLocalizations?.login_error_too_many_requests ?? "login_error_too_many_requests");
            break;

          // network inggeruptions
          case 'network-request-failed':
            showErrorDialog(appLocalizations?.login_error_network_error ?? "login_error_network_error");
            break;

          // user not waited for the web to finish verifying catcha
          case 'web-context-cancelled':
            showErrorDialog(appLocalizations?.login_error_web_context_canceled ?? "login_error_web_context_canceled");
            break;

          // cannot load captcha
          case 'web-internal-error':
            showErrorDialog(appLocalizations?.login_error_captcha_error ?? "login_error_captcha_error");
            break;

          // web context still presented but user requests new sesion
          case 'web-context-already-presented':
            // showErrorDialog(
            //     appLocalizations?.login_error_web_context_already_presented ??
            //         "login_error_web_context_already_presented");
            break;

          default:
            showErrorDialog(error.message ?? "unknow auth error [verifying phone number]");
        }

        // reverting all operations, start from the beginning
        _loginButtonEnabled = true;
        _loginInProcess = false;
        notifyListeners();
      },
      codeSent: (verificationId, forceResendingToken) {
        this.verificationId = verificationId;
        logger.i('code sent...');

        _isOtpCodeSent = true;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  /// Verifying the entered OTP
  verifyOTP() async {
    // block the continue button in the otp bottom sheet --> until the verification completed
    _otpVerifyInProcess = true;
    notifyListeners();

    // Create a PhoneAuthCredential with the otp code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otpCode!,
    );

    _signIn(credential);
  }

  void _signIn(PhoneAuthCredential credential) {
    AuthRepository.instance.signInWithCredential(credential).then(
      (userCredential) async {
        logger.i('signin success...');
        logger.i(userCredential);

        // if logged-in user with given phone number is not in the FireStore DB => delete the account
        if (!await UserRepository.isUserWithPhoneNumerExists(userCredential.user)) {
          userCredential.user?.delete().then(
            (value) {
              showErrorDialog(appLocalizations?.login_error_user_not_exists ?? "login_error_user_not_exists");

              logger.w('user deleted...');
            },
          ).catchError((onError) {
            logger.e('cannot delete the user...');
            logger.e(onError);
          });
        }
        // the user is exists
        else {
          logger.w('on user exists');
          logger.i(AuthRepository.instance.currentUser);
          await AuthRepository.updateUserFCMToken();
          Navigator.pushReplacementNamed(context, AppRoutes.home.name);
        }
      },
    ).catchError(
      (error) {
        logger.e('error verifying otp...');
        logger.e(error.toString());

        switch (error.code) {
          case 'invalid-verification-code':
            showErrorDialog(appLocalizations?.login_error_invalid_otp ?? "login_error_invalid_otp");
            break;

          case 'user-disabled':
            showErrorDialog(appLocalizations?.login_error_account_disabled ?? "login_error_account_disabled");
            break;

          case 'session-expired':
            showErrorDialog(appLocalizations?.login_error_otp_timeout ?? "login_error_otp_timeout");
            break;

          case 'network-request-failed':
            showErrorDialog(appLocalizations?.login_error_network_error ?? "login_error_network_error");
            break;

          default:
            showErrorDialog(error.toString());
        }
      },
    ).whenComplete(() {
      _otpVerifyInProcess = false;
      notifyListeners();
    });
  }
}
