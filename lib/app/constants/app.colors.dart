import 'package:flutter/material.dart';

class AppColor {
  static get mainColorLight => Colors.blue.shade300;
  static get mainColorDark => Colors.blue.shade800;
  static Color mainColor(ThemeMode themeMode) => themeMode == ThemeMode.light ? mainColorDark : mainColorLight;

  static get primarySwatch => Colors.blue;
  static get primarySwatchDark => AppColor.backgroundColorDark;

  // background color
  static get backgroundColorLight => const Color.fromRGBO(242, 242, 247, 1);
  static get backgroundColorDark => Colors.black;
  static Color backgroundColor(ThemeMode themeMode) =>
      themeMode == ThemeMode.light ? backgroundColorLight : backgroundColorDark;

  // navigator background color (floating on the background color)
  static get navigationBackgroundColorLight => Colors.white;
  static get navigationBackgroundColorDark => Colors.grey.shade900;
  static Color navigationBackgroundColor(ThemeMode themeMode) =>
      themeMode == ThemeMode.light ? navigationBackgroundColorLight : navigationBackgroundColorDark;

  // secondary background color (floating on the background color)
  static get secondaryBackgroundColorLight => Colors.white;
  static get secondaryBackgroundColorDark => Colors.black.withOpacity(0.5);
  static Color secondaryBackgroundColor(ThemeMode themeMode) =>
      themeMode == ThemeMode.light ? secondaryBackgroundColorLight : secondaryBackgroundColorDark;

  // border color (floating on the background color)
  static get borderColorLight => Colors.grey.withOpacity(0.3);
  static get borderColorDark => Colors.grey.withOpacity(0.9);
  static Color borderColor(ThemeMode themeMode) => themeMode == ThemeMode.light ? borderColorLight : borderColorDark;

  // text color
  static get textColorLight => Colors.black.withOpacity(0.8);
  static get textColorDark => Colors.white.withOpacity(0.8);
  static Color textColor(ThemeMode themeMode) => themeMode == ThemeMode.light ? textColorLight : textColorDark;

  static LinearGradient get mainAppBarGradientColor => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.blue.shade900,
          Colors.purple.shade800,
        ],
      );

  static LinearGradient get secondaryAppBarGradientColor => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.green.shade400,
          Colors.green.shade900,
        ],
      );
}
