import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseScreen<T extends BaseController> extends StatelessWidget {
  BaseScreen({Key? key, bool haveNavigationBar = true, String? previousPageTitle}) : super(key: key) {
    _previousPageTitle = previousPageTitle;
    _haveNavigationBar = haveNavigationBar;
  }

  @protected
  late final bool _haveNavigationBar;

  /// Screen build context, have access to the controller under the [body].
  /// TODO: make this field final on Production (non hot-reload) to reduce warnings
  @protected
  late BuildContext context;

  /// Previous screen title. Purpose is to display on the [CupertinoNavigationBar.previousPageTitle]
  @protected
  String? get previousPageTitle => _previousPageTitle;
  late final String? _previousPageTitle;

  /// Current screen controller.
  /// This step injects the controller into the widget tree,
  /// so you cannot access the controller [T] in this [context].
  T provideController(BuildContext context);

  /// Screen body.
  /// This context can access the controller [T].
  Widget body(BuildContext context);

  /// Trailing widget for the navigationbar, leave the function blank if dont want to show the navigationbar on screen.
  /// This [context] can access the controller [T].
  Widget? navigationBarTrailing(BuildContext context);

  /// screen navbar
  ObstructingPreferredSizeWidget? navigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      backgroundColor: AppColor.navigationBackgroundColor(context.read<AppController>().appThemeMode),
      transitionBetweenRoutes: true,
      previousPageTitle: previousPageTitle,
      middle: Text(
        context.read<T>().title,
        style: TextStyle(
          color: AppColor.textColor(context.read<AppController>().appThemeMode),
        ),
      ),
      trailing: navigationBarTrailing(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      lazy: false,
      create: (_) {
        // log('injecting controller');
        return provideController(context);
      },
      child: Builder(
        builder: (context) {
          this.context = context;
          return CupertinoPageScaffold(
            navigationBar: _haveNavigationBar ? navigationBar(context) : null,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              extendBody: true,
              body: body(context),
            ),
          );
        },
      ),
    );
  }
}
