import 'package:bvu_dormitory/app/app.logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRepository {
  static late SharedPreferences _prefs;
  static SharedPreferences get prefs => _prefs;

  static Future<void> initSharedPreferences() async {
    SharedPreferences.getInstance().then((value) {
      _prefs = value;
    }).catchError((onError) {
      logger.e('error init SharedPreferences');
      logger.e(onError);
    });
  }

  static ThemeMode get themMode {
    final themMode = prefs.getString('themeMode');

    // convert the string to a ThemeMode if the string's value is equal to any ThemeMode entry
    return ThemeMode.values.firstWhere(
      // describeEnum(@entry) => return only enum's @entry string value (not including the enum name itself)
      (element) => describeEnum(element) == themMode,

      // default value if cannot convert (not found any matching entries)
      orElse: () => ThemeMode.light,
    );
  }

  static setThemMode(ThemeMode mode) async {
    await prefs.setString('themeMode', describeEnum(mode));
  }
}
