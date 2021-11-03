import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/base/base.controller.dart';

import 'rooms.detail.items.controller.dart';

class AdminRoomsDetailItemsScreen extends BaseScreen<AdminRoomsDetailItemsController> {
  AdminRoomsDetailItemsScreen({Key? key, String? previousPageTitle})
      : super(key: key, previousPageTitle: previousPageTitle, haveNavigationBar: true);

  @override
  AdminRoomsDetailItemsController provideController(BuildContext context) {
    return AdminRoomsDetailItemsController(context: context, title: "");
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    return SafeArea(child: Container());
  }
}
