import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class AppStyles {
  static TextStyle get menuGroupTextStyle => TextStyle(
        color: Colors.black.withOpacity(0.5),
        fontWeight: FontWeight.w600,
        fontSize: 15,
      );

  static TextStyle getMenuGroupTextStyle(BuildContext context) {
    return TextStyle(
      color:
          context.read<AppController>().appThemeMode == ThemeMode.light ? Colors.black.withOpacity(0.6) : Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 15,
    );
  }
}
