import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseProvider extends ChangeNotifier {}

class AppController extends BaseController {
  late ThemeMode _appThemeMode = ThemeMode.dark;
  ThemeMode get appThemeMode => _appThemeMode;

  AppController({required BuildContext context}) : super(context: context, title: "") {
    checkConnectivity();
    loadTheme();
  }

  void checkConnectivity() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      showConnectionErrorDialog();
    }

    // listening to Connectivity states
    // Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   if (result == ConnectivityResult.none) {
    //     showConnectionErrorDialog();
    //   }
    // });
  }

  void showConnectionErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(appLocalizations?.app_dialog_title_error ?? "app_dialog_title_error"),
        content: Text(appLocalizations?.app_connectivity_none ?? "app_connectivity_none"),
        actions: [
          CupertinoDialogAction(child: Text(appLocalizations?.app_dialog_action_ok ?? "app_dialog_action_ok")),
        ],
      ),
    );
  }

  void changeTheme(ThemeMode mode) {
    _appThemeMode = mode;

    SharedPreferences.getInstance().then((instance) {
      instance.setString('theme_mode', describeEnum(mode));
    });

    notifyListeners();
  }

  void loadTheme() {
    SharedPreferences.getInstance().then((instance) {
      changeTheme(
        ThemeMode.values.firstWhere((element) => describeEnum(element) == instance.getString('theme_mode'),
            orElse: () => ThemeMode.dark),
      );
    });
  }
}
