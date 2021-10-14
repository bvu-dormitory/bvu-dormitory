import 'package:bvu_dormitory/screens/admin/home/admin.home.controller.dart';
import 'package:bvu_dormitory/screens/admin/home/widgets/admin.home.navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatefulWidget {
  AdminHomeScreen({Key? key}) : super(key: key);

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminHomeController(context: _),
      child: AdminHomeBottomNavbar(),
    );
  }
}
