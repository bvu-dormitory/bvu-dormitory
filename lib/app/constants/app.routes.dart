import 'package:bvu_dormitory/screens/admin/manage/buildings/buildings.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/students/students.screen.dart';
import 'package:bvu_dormitory/screens/shared/403/403.screen.dart';
import 'package:bvu_dormitory/screens/shared/404/404.screen.dart';
import 'package:bvu_dormitory/screens/shared/home/home.screen.dart';
import 'package:bvu_dormitory/screens/shared/login/login.screen.dart';
import 'package:flutter/widgets.dart';

class AppRoute {
  late final String _name;
  late final Widget _screen;

  String get name => _name;
  Widget get screen => _screen;

  AppRoute({required String name, required screen}) {
    _name = name;
    _screen = screen;
  }
}

class AppRoutes {
  //
  //
  // shared routes
  static AppRoute get home => AppRoute(
        name: '/home',
        screen: const HomeScreen(),
      );
  static AppRoute get login => AppRoute(
        name: '/login',
        screen: const LoginScreen(),
      );
  static AppRoute get notFound => AppRoute(
        name: '/404',
        screen: const NotFoundScreen(),
      );
  static AppRoute get forBidden => AppRoute(
        name: '/403',
        screen: const ForBiddenScreen(),
      );

  //
  //
  // admin routes
  static AppRoute get adminRooms => AppRoute(
        name: '/admin-rooms',
        screen: AdminBuildingsScreen(),
      );
  // static AppRoute get students => AppRoute(
  //       name: '/admin-students',
  //       screen: AdminStudentsScreen(),
  //     );

  //
  //
  //
  //
  // private list for mapping
  static List<AppRoute> get _list => [
        notFound,
        forBidden,
        home,
        login,
        adminRooms,
      ];

  // mapping the above "_list" so this can be assigned to MaterialApp.routes config
  static Map<String, Widget Function(BuildContext)> get go => Map.fromEntries(
        _list.map((e) => MapEntry(e.name, (BuildContext context) => e.screen)),
      );

  // getting route matched to a name
  static AppRoute getByName(String routeName) {
    return _list.firstWhere((element) => element.name == routeName);
  }
}
