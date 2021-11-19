import 'package:flutter/material.dart';

class AppColor {
  static get primarySwatch => Colors.blue;
  static get primarySwatchDark => AppColor.backgroundColorDark;

  static get backgroundColor => const Color.fromRGBO(242, 242, 247, 1);
  static get backgroundColorDark => Colors.grey;

  static get secondaryBackgroundColor => Colors.white.withOpacity(0.5);
  static get secondaryBackgroundColorDark => Colors.grey.withOpacity(0.5);

  static get textColor => Colors.grey;
  static get textColorDark => Colors.white;

  static get mainColor => Colors.blue.shade800;
  static LinearGradient get mainAppBarGradientColor => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.blue.shade900,
          Colors.purple.shade800,
        ],
      );
}
