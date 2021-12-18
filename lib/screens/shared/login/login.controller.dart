import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:bvu_dormitory/repositories/auth.repository.dart';
import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/app/app.logger.dart';

class LoginController extends BaseController {
  LoginController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  // native firebase auth params
  static const Duration OTP_TIMEOUT = Duration(seconds: 10);
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

  int _timeout = OTP_TIMEOUT.inSeconds;
  int get timeOut => _timeout;

  Key _screenKey = UniqueKey();
  Key get screenKey => _screenKey;

  late Timer _timeoutConter;
  Timer get timerConter => _timeoutConter;

  void showOTPBottomSheet() {
    _isOtpCodeSent = true;
    notifyListeners();
  }

  void hideOTPBottomSheet() {
    _isOtpCodeSent = false;
    _loginButtonEnabled = true;
    _loginInProcess = false;

    if (_timeoutConter.isActive) {
      _timeoutConter.cancel();
    }
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
      timeout: OTP_TIMEOUT,
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

        // begin counting timeout
        _timeout = OTP_TIMEOUT.inSeconds;
        _timeoutConter = Timer.periodic(const Duration(seconds: 1), (timer) {
          _timeout -= 1;

          // timed out
          if (_timeout == 0) {
            log('timeout');
            showConfirmDialog(
              title: appLocalizations!.app_dialog_title_warning,
              body: Text(appLocalizations!.login_error_otp_timeout),
              confirmType: DialogConfirmType.submit,
              onSubmit: () {
                navigator.pop();
                _isOtpCodeSent = false;
                _loginInProcess = false;
                _loginButtonEnabled = true;
                notifyListeners();
              },
            );
            timer.cancel();
          }

          notifyListeners();
        });
        // Stream.periodic(const Duration(seconds: 1), (value) {
        //   _timeout -= 1;
        //   if (_timeout == 0) {
        //     log('timeout');
        //   }
        //   log('timeout tick...');
        //   notifyListeners();
        // }).take(OTP_TIMEOUT.inSeconds);

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
        logger.i('signin success....');
        logger.i(userCredential);
        logger.i(AuthRepository.instance.currentUser);

        // updating the FCM token for this device
        await AuthRepository.updateUserFCMToken();

        // navigate to the home screen
        // Navigator.pushReplacement(
        //     context,
        //     CupertinoPageRoute(
        //       builder: (context) => const HomeScreen(),
        //     ));
      },
    ).catchError(
      (error) {
        logger.e('error verifying otp...');
        logger.e(error.toString());

        switch (error.code) {
          case 'invalid-verification-code':
            showErrorDialog(appLocalizations!.login_error_invalid_otp);
            break;

          case 'user-disabled':
            showErrorDialog(appLocalizations!.login_error_account_disabled);
            break;

          case 'session-expired':
            showErrorDialog(appLocalizations!.login_error_otp_timeout);
            break;

          case 'network-request-failed':
            showErrorDialog(appLocalizations!.login_error_network_error);
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
