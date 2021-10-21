import 'dart:developer';

import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseScreen<T extends BaseController> extends StatelessWidget {
  BaseScreen({Key? key, String? previousPageTitle}) : super(key: key) {
    _previousPageTitle = previousPageTitle;
  }

  /// previous screen title
  @protected
  String? get previousPageTitle => _previousPageTitle;
  late final String? _previousPageTitle;

  /// current screen title
  String provideTitle(BuildContext context);

  /// current screen controller
  T provideController(BuildContext context);

  /// screen body
  Widget body(BuildContext context);

  /// screen navbar
  CupertinoNavigationBar? navigationBar(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      lazy: false,
      create: (_) {
        log('injecting controller');
        return provideController(context);
      },
      child: Builder(
        builder: (context) {
          return CupertinoPageScaffold(
            backgroundColor: AppColor.backgroundColor,
            navigationBar: navigationBar(context),
            child: Scaffold(
              backgroundColor: AppColor.backgroundColor,
              body: body(context),
            ),
          );
        },
      ),
    );
  }
}
