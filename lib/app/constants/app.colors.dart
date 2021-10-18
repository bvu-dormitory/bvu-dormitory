import 'package:flutter/material.dart';

class AppColor {
  static get primarySwatch => Colors.blue;
  static get primarySwatchDark => AppColor.backgroundColorDark;

  static get backgroundColor => Colors.lightBlue.withOpacity(0.05);
  static get backgroundColorDark => Colors.grey;

  static get secondaryBackgroundColor => Colors.white.withOpacity(0.5);
  static get secondaryBackgroundColorDark => Colors.grey.withOpacity(0.5);

  static get textColor => Colors.grey;
  static get textColorDark => Colors.white;
}
