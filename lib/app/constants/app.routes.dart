import 'package:bvu_dormitory/screens/shared/home/home.screen.dart';
import 'package:bvu_dormitory/screens/shared/login/login.screen.dart';
import 'package:flutter/widgets.dart';

class AppRoute {
  final String _name;
  final Widget _screen;

  String get name => _name;
  Widget get screen => _screen;

  AppRoute(this._name, this._screen);
}

class AppRoutes {
  static AppRoute get home => AppRoute('/home', HomeScreen());
  static AppRoute get login => AppRoute('/login', LoginScreen());

  static Map<String, Widget Function(BuildContext)> collect() => {
        // '/': (_) => const LoginScreen(),
        '/home': (_) => HomeScreen(),
        '/login': (_) => LoginScreen(),
      };
}
