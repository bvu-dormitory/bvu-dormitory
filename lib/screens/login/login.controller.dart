import 'dart:async';
import 'dart:developer';

import 'package:bvu_dormitory/constants/app.routes.dart';
import 'package:bvu_dormitory/repositories/auth.repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/repositories/user.repository.dart';

class AuthController extends BaseController {
  AuthController({required BuildContext context}) : super(context: context);

  // native firebase auth params
  FirebaseAuth authInstance = FirebaseAuth.instance;
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

        log('verificationCompleted');
        return;
      },
      verificationFailed: (error) {
        print('error authenticating phone..');
        print(error);

        switch (error.code) {
          // user has tried to login so many times in a short period of time
          case 'too-many-requests':
            showErrorDialog(appLocalizations?.login_error_too_many_requests ??
                "login_error_too_many_requests");
            break;

          // network inggeruptions
          case 'network-request-failed':
            showErrorDialog(appLocalizations?.login_error_network_error ??
                "login_error_network_error");
            break;

          // user not waited for the web to finish verifying catcha
          case 'web-context-cancelled':
            showErrorDialog(
                appLocalizations?.login_error_web_context_canceled ??
                    "login_error_web_context_canceled");
            break;

          // cannot load captcha
          case 'web-internal-error':
            showErrorDialog(appLocalizations?.login_error_captcha_error ??
                "login_error_captcha_error");
            break;

          // web context still presented but user requests new sesion
          case 'web-context-already-presented':
            showErrorDialog(
                appLocalizations?.login_error_web_context_already_presented ??
                    "login_error_web_context_already_presented");
            break;

          default:
            showErrorDialog(
                error.message ?? "unknow auth error [verifying phone number]");
        }

        // reverting all operations, start from the beginning
        _loginButtonEnabled = true;
        _loginInProcess = false;
        notifyListeners();
      },
      codeSent: (verificationId, forceResendingToken) {
        this.verificationId = verificationId;
        print('code sent...');

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

    // Sign the user in (or link) with the credential
    log('signingin...');
    authInstance.signInWithCredential(credential).then(
      (userCredential) async {
        log('signing in success...');
        print(userCredential);

        // if the logged-in user with given phone number is not in DB => delete the account
        if (!(await UserRepository.isUserWithPhoneNumerExists(
            userCredential.user))) {
          userCredential.user?.delete().then((value) {
            showErrorDialog(appLocalizations?.login_error_user_not_exists ??
                "login_error_user_not_exists");
          }).catchError((onError) {
            log('cannot delete the user...');
            print(onError);
          });
        }
        // the user is exists
        else {
          Navigator.pushNamed(context, AppRoutes.home.name);
        }
      },
    ).catchError(
      (error) {
        print('error verifying otp...');
        // print(error.message);

        switch (error.code) {
          case 'invalid-verification-code':
            showErrorDialog(appLocalizations?.login_error_invalid_otp ??
                "login_error_invalid_otp");
            break;

          case 'session-expired':
            showErrorDialog(appLocalizations?.login_error_otp_timeout ??
                "login_error_otp_timeout");
            break;

          case 'network-request-failed':
            showErrorDialog(appLocalizations?.login_error_network_error ??
                "login_error_network_error");
            break;

          default:
            showErrorDialog(error ?? "unknow auth error [verifying otp code]");
        }
      },
    ).whenComplete(() {
      _otpVerifyInProcess = false;
      notifyListeners();
    });
  }
}
