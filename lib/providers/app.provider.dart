import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {}

enum AppThemeMode {
  light,
  dark,
  system,
}

class AppProvider extends BaseProvider {
  late AppThemeMode _appThemeMode;
  get appThemeMode => _appThemeMode;

  void changeTheme(AppThemeMode mode) {
    _appThemeMode = mode;
    notifyListeners();
  }
}
