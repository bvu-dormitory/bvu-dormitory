import 'package:flutter/material.dart';

import 'app.colors.dart';

class AppThemes {
  static get light => ThemeData(
        primarySwatch: AppColor.primarySwatch,
        backgroundColor: AppColor.backgroundColor,
        brightness: Brightness.light,
      );

  static get dark => ThemeData(
        primarySwatch: AppColor.primarySwatchDark,
        backgroundColor: AppColor.backgroundColorDark,
        brightness: Brightness.dark,
      );
}
