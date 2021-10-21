import 'package:flutter/cupertino.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'buildings.search.controller.dart';

class AdminBuildingsSearchScreen
    extends BaseScreen<AdminBuildingsSearchController> {
  AdminBuildingsSearchScreen({
    Key? key,
    required String previousPageTitle,
  }) : super(key: key, previousPageTitle: previousPageTitle);

  @override
  CupertinoNavigationBar? navigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      previousPageTitle: previousPageTitle,
    );
  }

  @override
  AdminBuildingsSearchController provideController(BuildContext context) {
    return AdminBuildingsSearchController(
        context: context, title: provideTitle(context));
  }

  @override
  String provideTitle(BuildContext context) {
    return "";
  }

  @override
  Widget body(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text('search'),
      ),
    );
  }
}
