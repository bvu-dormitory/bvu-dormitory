import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseScreen<T extends BaseController> extends StatelessWidget {
  BaseScreen({
    Key? key,
    required String previousPageTitle,
  }) {
    _previousPageTitle = previousPageTitle;
  }

  /// previous screen title
  @protected
  String get previousPageTitle => _previousPageTitle;
  late final String _previousPageTitle;

  /// screen controller
  @protected
  T get controller => _controller;
  late final T _controller;

  /// screen body
  Widget body(BuildContext context);

  /// screen navbar
  CupertinoNavigationBar? navigationBar(BuildContext context);

  initController(BuildContext context);

  @override
  Widget build(BuildContext context) {
    _controller = initController(context);

    return ChangeNotifierProvider.value(
      value: _controller,
      child: CupertinoPageScaffold(
        navigationBar: navigationBar(context),
        child: body(context),
      ),
    );
  }
}
