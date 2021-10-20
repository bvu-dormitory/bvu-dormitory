import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                color: Colors.blue,
                width: double.infinity,
                height: 300,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                color: Colors.blue,
                width: double.infinity,
                height: 300,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                color: Colors.red,
                width: double.infinity,
                height: 300,
              ),
              const SizedBox(
                height: 30,
              ),
              const TextField(),
            ],
          ),
        ),
      ),
    );
  }
}
