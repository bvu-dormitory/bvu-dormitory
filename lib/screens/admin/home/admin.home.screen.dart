import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/screens/admin/home/admin.home.controller.dart';
import 'package:bvu_dormitory/screens/admin/home/widgets/admin.home.navbar.dart';

class AdminHomeScreen extends BaseScreen<AdminHomeController> {
  AdminHomeScreen({Key? key}) : super(key: key, haveNavigationBar: false);

  @override
  AdminHomeController provideController(BuildContext context) {
    return AdminHomeController(context: context, title: "");
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    return const AdminHomeBottomNavbar();
  }
}
