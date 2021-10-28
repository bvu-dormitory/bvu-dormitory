import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/students/rooms.detail.students.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/students/add/rooms.details.students.add.screen.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/user.dart';

import 'package:bvu_dormitory/repositories/building.repository.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';

class AdminRoomsDetailStudentsScreen extends BaseScreen<AdminRoomsDetailStudentsController> {
  AdminRoomsDetailStudentsScreen({
    Key? key,
    required String previousPageTitle,
    required this.building,
    required this.floor,
    required this.room,
  }) : super(key: key, previousPageTitle: previousPageTitle);

  final Building building;
  final Floor floor;
  final Room room;

  @override
  Widget? navigationBarTrailing(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Icon(FluentIcons.person_add_24_regular),
      onPressed: () {
        Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => AdminRoomsDetailStudentsAddScreen(
            building: building,
            floor: floor,
            room: room,
            previousPageTitle: "",
          ),
        ));
      },
    );
  }

  @override
  AdminRoomsDetailStudentsController provideController(BuildContext context) {
    return AdminRoomsDetailStudentsController(
      context: context,
      title: AppLocalizations.of(context)!.admin_manage_student,
      building: building,
      floor: floor,
      room: room,
    );
  }

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: room.studentIdList != null ? _studentsList() : Text(AppLocalizations.of(context)!.admin_manage_rooms_detail_students_empty),
      ),
    );
  }

  _studentsList() {
    final controller = context.read<AdminRoomsDetailStudentsController>();

    return FutureBuilder<List<Student>?>(
      future: BuildingRepository.getStudentsInRoom(room.studentIdList!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          log('getting students in the room done');

          if (snapshot.hasData) {
            return AppMenuGroup(
              items: snapshot.data!
                  .map((e) => AppMenuGroupItem(
                        title: e.fullName,
                        titleStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        subTitle: Text(e.id!),
                        onPressed: () => controller.onStudentItemPressed(e),
                      ))
                  .toList(),
            );
          }

          if (snapshot.hasError) {
            controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 3), () {});
            return const Scaffold(
              body: Center(
                child: Text('Error'),
              ),
            );
          }
        }

        return const Scaffold(
          body: Center(
            child: CupertinoActivityIndicator(radius: 15),
          ),
        );
      },
    );
  }
}
