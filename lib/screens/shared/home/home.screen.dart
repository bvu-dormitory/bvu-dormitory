import 'dart:developer';

import 'package:bvu_dormitory/repositories/auth.repository.dart';
import 'package:bvu_dormitory/repositories/user.repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/screens/admin/home/home.screen.dart';
import 'package:bvu_dormitory/screens/student/home/student.home.screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser?>(
      future: UserRepository.getCurrentFireStoreUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(snapshot.error.toString()),
              ),
            );

            return const Scaffold(
              body: Center(
                child: Text('Error'),
              ),
            );
          }
          return snapshot.data!.role == UserRole.admin
              ? AdminHomeScreen()
              : StudentHomeScreen(student: snapshot.data! as Student);
        }

        log('Checking user role...');
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
