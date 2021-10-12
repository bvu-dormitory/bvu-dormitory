import 'package:bvu_dormitory/app/app.provider.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppProvider appProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appProvider = Provider.of<AppProvider>(context);
  }

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
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.black,
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
          CupertinoButton(
            child: Text('Toggle theme'),
            onPressed: () {
              // Provider.of(context).
              appProvider.changeTheme(ThemeMode.dark);
            },
          ),
        ],
      )),
    );
  }
}
