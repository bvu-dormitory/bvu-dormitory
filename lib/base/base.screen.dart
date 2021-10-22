import 'dart:developer';

import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseScreen<T extends BaseController> extends StatelessWidget {
  BaseScreen(
      {Key? key, bool haveNavigationBar = true, String? previousPageTitle})
      : super(key: key) {
    _previousPageTitle = previousPageTitle;
    _haveNavigationBar = haveNavigationBar;
  }

  @protected
  late final bool _haveNavigationBar;

  /// previous screen title
  @protected
  String? get previousPageTitle => _previousPageTitle;
  late final String? _previousPageTitle;

  /// current screen controller
  T provideController(BuildContext context);

  /// screen body
  Widget body(BuildContext context);

  /// trailing widget for the navigationbar, avoid return if the screen doesnt want to show the navigationbar
  Widget? navigationBarTrailing(BuildContext context);

  /// screen navbar
  CupertinoNavigationBar? navigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      transitionBetweenRoutes: true,
      previousPageTitle: previousPageTitle,
      middle: Text(context.read<T>().title),
      trailing: navigationBarTrailing(context),
    );
  }

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
            navigationBar: _haveNavigationBar ? navigationBar(context) : null,
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
