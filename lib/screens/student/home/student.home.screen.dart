import 'package:bvu_dormitory/screens/student/home/student.home.controller.dart';
import 'package:bvu_dormitory/screens/student/home/widgets/student.home.navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({Key? key}) : super(key: key);

  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudentHomeController(context: _),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(10),
          child: const Center(
            child: Text(
              'Student',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        bottomNavigationBar: const StudentHomeBottomNavbar(),
      ),
    );
  }
}
