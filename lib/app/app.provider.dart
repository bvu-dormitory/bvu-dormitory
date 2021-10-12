import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {}

class AppProvider extends BaseProvider {
  late ThemeMode _appThemeMode = ThemeMode.system;
  get appThemeMode => _appThemeMode;

  void changeTheme(ThemeMode mode) {
    _appThemeMode = mode;
    notifyListeners();
  }
}
