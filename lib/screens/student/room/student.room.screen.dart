import 'package:bvu_dormitory/repositories/auth.repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'student.room.controller.dart';

class StudentRoomScreen extends BaseScreen<StudentRoomController> {
  StudentRoomScreen({Key? key, String? previousPageTitle})
      : super(key: key, previousPageTitle: previousPageTitle, haveNavigationBar: false);

  @override
  StudentRoomController provideController(BuildContext context) {
    return StudentRoomController(
      context: context,
      title: AppLocalizations.of(context)!.admin_manage_room,
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    return SafeArea(
        child: Container(
      child: TextButton(
        onPressed: () {
          AuthRepository.signOut();
        },
        child: Text('Log out'),
      ),
    ));
  }
}
