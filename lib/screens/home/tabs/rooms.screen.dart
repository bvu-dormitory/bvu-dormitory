import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoomsScreen extends StatefulWidget {
  RoomsScreen({Key? key}) : super(key: key);

  @override
  _RoomsScreenState createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // appBar: AppBar(
      //   title: const Text('Rooms'),
      // ),
      // body: Center(
      //   child: CupertinoButton(
      //       child: Text('Sign out'),
      //       onPressed: () {
      //         FirebaseAuth.instance.signOut();
      //       }),
      // ),
      navigationBar: const CupertinoNavigationBar(
        padding: EdgeInsetsDirectional.all(10),
        previousPageTitle: 'Trang chủ',
        leading: Text(
          'Rooms',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        // transitionBetweenRoutes: true,
      ),
      child: Center(
        child: CupertinoButton(
            child: Text('Sign out'),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            }),
      ),
    );
  }
}
