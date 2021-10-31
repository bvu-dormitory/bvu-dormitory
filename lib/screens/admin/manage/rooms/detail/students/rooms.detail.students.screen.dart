import 'dart:developer';

import 'package:bvu_dormitory/repositories/room.repository.dart';
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
        Navigator.of(context)
            .push(CupertinoPageRoute(
          builder: (_) => AdminRoomsDetailStudentsAddScreen(
            building: building,
            floor: floor,
            room: context.read<AdminRoomsDetailStudentsController>().room,
            previousPageTitle: context.read<AdminRoomsDetailStudentsController>().title,
          ),
        ))
            .then((value) {
          // reload data after the StudentAddScreen popped
          context.read<AdminRoomsDetailStudentsController>().notifyListeners();
        });
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
        child: room.studentIdList != null
            ? _studentsList()
            : Text(AppLocalizations.of(context)!.admin_manage_rooms_detail_students_empty),
      ),
    );
  }

  _studentsList() {
    final controller = context.watch<AdminRoomsDetailStudentsController>();

    return FutureBuilder<Room>(
      future: controller.loadRoom(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 3), () {});
              return const SafeArea(
                child: Center(
                  child: Text('Error'),
                ),
              );
            }

            if (snapshot.hasData) {
              controller.room = snapshot.data!;

              return FutureBuilder<List<Student>?>(
                future: RoomRepository.getStudentsInRoom(snapshot.data!.studentIdList!),
                builder: (context, snapshot) {
                  return _loadStudents(snapshot);
                },
              );
            } else {
              return const Center(
                child: Text('No data.'),
              );
            }
          default:
            return const SafeArea(
              child: Center(
                child: CupertinoActivityIndicator(radius: 15),
              ),
            );
        }
      },
    );
  }

  _loadStudents(AsyncSnapshot<List<Student>?> snapshot) {
    final controller = context.read<AdminRoomsDetailStudentsController>();

    switch (snapshot.connectionState) {
      case ConnectionState.done:
        if (snapshot.hasError) {
          controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 3), () {});
          return const SafeArea(
            child: Center(
              child: Text('Error'),
            ),
          );
        }

        if (snapshot.hasData) {
          return AppMenuGroup(
            items: snapshot.data!
                .map((student) => AppMenuGroupItem(
                      title: student.fullName,
                      titleStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      subTitle: Text(student.id!),
                      onPressed: () => controller.onStudentItemPressed(student),
                    ))
                .toList(),
          );
        } else {
          return const Center(
            child: Text('No data.'),
          );
        }

      default:
        return const Center(
          child: CupertinoActivityIndicator(radius: 15),
        );
    }
  }
}
