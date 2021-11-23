import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.colors.dart';

class AppThemes {
  static get light => ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColor.backgroundColorLight,
      );

  static get dark => ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: AppColor.backgroundColorLight,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColor.backgroundColorDark,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColor.backgroundColorDark,
        ),
      );
}
