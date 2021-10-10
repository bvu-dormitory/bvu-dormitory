import 'package:bvu_dormitory/screens/login/login.screen.dart';
import 'package:bvu_dormitory/screens/home/home.screen.dart';
import 'package:flutter/widgets.dart';

class AppRoute {
  String _name;
  Widget _screen;

  String get name => _name;
  Widget get screen => _screen;

  AppRoute(this._name, this._screen);
}

class AppRoutes {
  static AppRoute get home => AppRoute('home', HomeScreen());
  static AppRoute get login => AppRoute('login', LoginScreen());

  static Map<String, Widget Function(BuildContext)> collect() => {
        // '/': (_) => const LoginScreen(),
        '/home': (_) => HomeScreen(),
      };
}
