import 'package:bvu_dormitory/repositories/auth.repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('abc');
    print(FirebaseAuth.instance.currentUser);
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        return Scaffold(
          body: SafeArea(
            child: Text(snapshot.data.toString()),
          ),
        );
      },
    );
  }
}
