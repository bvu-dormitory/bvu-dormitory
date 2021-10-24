import 'package:bvu_dormitory/repositories/auth.repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/screens/admin/home/home.screen.dart';
import 'package:bvu_dormitory/screens/student/home/student.home.screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // stream: FirebaseAuth.instance.userChanges(),
      future: AuthRepository.getCurrentUserRole(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data == UserRole.admin ? AdminHomeScreen() : const StudentHomeScreen();
        }

        // cannot load current logged in user's role
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CupertinoActivityIndicator(
              radius: 15,
            ),
          ),
        );
      },
    );
  }
}
