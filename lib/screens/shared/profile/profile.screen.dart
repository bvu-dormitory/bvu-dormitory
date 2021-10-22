import 'package:flutter/material.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'profile.controller.dart';

class ProfileScreen extends BaseScreen<ProfileController> {
  ProfileScreen({Key? key}) : super(key: key, haveNavigationBar: false);

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: MediaQuery.of(context).padding.top,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
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
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  provideController(BuildContext context) {
    return ProfileController(context: context, title: "");
  }
}
