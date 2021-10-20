import 'dart:ui';

import 'package:bvu_dormitory/screens/shared/login/login.controller.dart';
import 'package:bvu_dormitory/screens/shared/login/widgets/login.login_button.dart';
import 'package:bvu_dormitory/screens/shared/login/widgets/login.otp_bottomsheet.dart';
import 'package:bvu_dormitory/screens/shared/login/widgets/login.phone_field.dart';
import 'package:bvu_dormitory/screens/shared/login/widgets/login.title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // setup statusbar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<LoginController>(
        create: (_) => LoginController(context: context),
        child: _body(),
      ),
    );
  }

  _body() {
    return GestureDetector(
      // hide soft keyboard on tap background
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Stack(
        children: [
          // background image
          _backgroundImage(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            // Gradient overlay
            decoration: _gradientOverlay(),
            child: SafeArea(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const LoginTitle(),
                Stack(
                  children: const [
                    LoginPhoneField(),
                    Positioned(
                      child: LoginButton(),
                      top: 0,
                      right: 0,
                      // top: 2,
                      // right: 2.5,
                    ),
                  ],
                )
              ],
            )),
          ),

          const LoginOTPBottomSheet(),
        ],
      ),
    );
  }

  BoxDecoration _gradientOverlay() => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Colors.blue.withOpacity(0.05),
            Colors.blueAccent.shade400.withOpacity(0.9),
          ],
        ),
      );

  Image _backgroundImage() => Image.asset(
        'lib/assets/cs2.jpg',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
      );
}
