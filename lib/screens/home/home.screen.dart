import 'package:bvu_dormitory/screens/home/tabs/rooms.screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // appBar: AppBar(
      //   title: const Text('Trang chủ'),
      // ),
      // body: Center(
      //   child: CupertinoButton(
      //       child: Text('Sign out'),
      //       onPressed: () {
      //         Navigator.of(context).push(MaterialPageRoute(
      //           builder: (context) => RoomsScreen(),
      //         ));
      //       }),
      // ),
      navigationBar: const CupertinoNavigationBar(
        padding: EdgeInsetsDirectional.all(10),
        leading: Text(
          'Trang chủ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        transitionBetweenRoutes: true,
      ),
      child: SafeArea(
          child: Column(
        children: [
          CupertinoButton(
            child: Text('Sign out'),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
          CupertinoButton(
            child: Text('Listen'),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('users/managers/data')
                  .snapshots()
                  .listen((event) {
                print(event.docs.first.data());
              });
            },
          ),
        ],
      )),
    );
  }
}
