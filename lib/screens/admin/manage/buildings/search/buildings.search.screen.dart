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
  AdminBuildingsSearchController provideController(BuildContext context) {
    return AdminBuildingsSearchController(context: context, title: "");
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text('search'),
      ),
    );
  }
}
