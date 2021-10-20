import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/screens/admin/home/admin.home.controller.dart';
import 'package:bvu_dormitory/screens/admin/home/widgets/admin.home.navbar.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminHomeController(context: _),
      child: const AdminHomeBottomNavbar(),
    );
  }
}
