import 'package:flutter/material.dart';

class AdminReportsScreen extends StatefulWidget {
  AdminReportsScreen({Key? key}) : super(key: key);

  @override
  _AdminReportsScreenState createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Reports'),
        ),
      ),
    );
  }
}
