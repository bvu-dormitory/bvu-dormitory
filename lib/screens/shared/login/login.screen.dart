import 'dart:developer';
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
        create: (_) => LoginController(context: context, title: ""),
        child: _body(),
      ),
    );
    // return Scaffold(
    //   key: key,
    //   body: ChangeNotifierProvider<LoginController>(
    //     create: (_) => LoginController(context: context, title: ""),
    //     child: _body(),
    //   ),
    // );
  }

  _body() {
    return Selector<LoginController, Key>(
      selector: (p0, p1) => p1.screenKey,
      builder: (_, value, __) => GestureDetector(
        key: value,
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
      ),
    );
  }

  BoxDecoration _gradientOverlay() => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Colors.blue.withOpacity(0.5),
            Colors.deepPurple.shade900.withOpacity(0.79),
          ],
        ),
      );

  _backgroundImage() => Image.asset(
        'lib/assets/cs2.jpg',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        filterQuality: FilterQuality.high,
      );
}
