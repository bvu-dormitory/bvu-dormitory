import 'package:flutter/material.dart';

class ManageScreen extends StatefulWidget {
  ManageScreen({Key? key}) : super(key: key);

  @override
  _ManageScreenState createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              width: double.infinity,
              height: 300,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              color: Colors.blue,
              width: double.infinity,
              height: 300,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              color: Colors.red,
              width: double.infinity,
              height: 300,
            ),
            SizedBox(
              height: 30,
            ),
            TextField(),
          ],
        ),
      ),
    ));
  }
}
