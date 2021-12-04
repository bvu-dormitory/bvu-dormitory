import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.colors.dart';

class AppThemes {
  static get light => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColor.backgroundColorLight,
      );

  static get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColor.backgroundColorDark,
      );
}
