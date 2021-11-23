import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/room.repository.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:provider/src/provider.dart';
import 'student.members.controller.dart';

class StudentMembersScreen extends BaseScreen<StudentMemnbersController> {
  StudentMembersScreen({
    Key? key,
    String? previousPageTitle,
    required this.room,
  }) : super(key: key, previousPageTitle: "$previousPageTitle ${room.name}", haveNavigationBar: true);

  final Room room;

  @override
  StudentMemnbersController provideController(BuildContext context) {
    return StudentMemnbersController(context: context, title: AppLocalizations.of(context)!.admin_manage_members);
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

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
                        .read<StudentMemnbersController>()
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
                            onChanged: null,
                          ),
                          // onPressed: () =>
                          //     context.read<StudentMemnbersController>().onStudentItemPressed(student),
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
