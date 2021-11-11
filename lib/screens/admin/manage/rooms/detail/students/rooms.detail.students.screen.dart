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
import 'package:bvu_dormitory/repositories/room.repository.dart';
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
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => AdminRoomsDetailStudentsAddScreen(
              building: building,
              floor: floor,
              room: context.read<AdminRoomsDetailStudentsController>().room,
              previousPageTitle: context.read<AdminRoomsDetailStudentsController>().title,
            ),
          ),
        );
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
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder<List<Student>>(
            stream: RoomRepository.syncStudentsInRoom(room),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    context
                        .read<AdminRoomsDetailStudentsController>()
                        .showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
                  }

                  if (snapshot.hasData) {
                    return AppMenuGroup(
                        items: snapshot.data!.map(
                      (student) {
                        return AppMenuGroupItem(
                          title: student.fullName,
                          titleStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                          subTitle: Text(student.id!),
                          trailing: CupertinoSwitch(
                            value: student.isActive,
                            onChanged: (value) => context
                                .read<AdminRoomsDetailStudentsController>()
                                .onStudentActiveStateChanged(student, value),
                          ),
                          onPressed: () =>
                              context.read<AdminRoomsDetailStudentsController>().onStudentItemPressed(student),
                        );
                      },
                    ).toList());
                  } else {
                    return SafeArea(
                      child: Text(AppLocalizations.of(context)!.admin_manage_rooms_detail_students_empty),
                    );
                  }

                default:
                  return const SafeArea(
                    child: Center(
                      child: CupertinoActivityIndicator(
                        radius: 10,
                      ),
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
