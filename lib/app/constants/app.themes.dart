import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.colors.dart';

class AppThemes {
  static get light => ThemeData(
        primarySwatch: AppColor.primarySwatch,
        backgroundColor: AppColor.backgroundColor,
        brightness: Brightness.light,
        // fontFamily: GoogleFonts.montserrat().fontFamily,
      );

  static get dark => ThemeData(
        primarySwatch: AppColor.primarySwatchDark,
        backgroundColor: AppColor.backgroundColorDark,
        brightness: Brightness.dark,
        // fontFamily: GoogleFonts.montserrat().fontFamily,
      );
}
