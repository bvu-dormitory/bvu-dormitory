import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
      ),
    );
  }
}
