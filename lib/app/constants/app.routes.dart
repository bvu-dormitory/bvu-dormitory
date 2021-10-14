import 'package:bvu_dormitory/screens/shared/403/403.screen.dart';
import 'package:bvu_dormitory/screens/shared/404/404.screen.dart';
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
  static AppRoute get notFound => AppRoute('404', const NotFoundScreen());
  static AppRoute get forBidden => AppRoute('403', const ForBiddenScreen());

  static AppRoute get home => AppRoute('home', HomeScreen());
  static AppRoute get login => AppRoute('login', LoginScreen());

  static List<AppRoute> get _list => [
        notFound,
        forBidden,
        home,
        login,
      ];

  // mapping the above "_list" so this can be assigned to MaterialApp.routes config
  static Map<String, Widget Function(BuildContext)> get collection =>
      Map.fromIterable(
        _list.map((e) => MapEntry(e.name, (BuildContext context) => e.screen)),
      );

  // getting route matched to a name
  static AppRoute getByName(String routeName) {
    return _list.firstWhere((element) => element.name == routeName);
  }
}
