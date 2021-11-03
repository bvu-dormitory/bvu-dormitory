import 'dart:developer';

import 'package:bvu_dormitory/repositories/student.repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/room.repository.dart';
import 'package:bvu_dormitory/screens/admin/manage/buildings/buildings.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/students/add/rooms.details.students.add.screen.dart';

class AdminRoomsDetailStudentsController extends BaseController {
  AdminRoomsDetailStudentsController({
    required BuildContext context,
    required String title,
    required this.building,
    required this.floor,
    required this.room,
  }) : super(context: context, title: title);

  Building building;
  Floor floor;
  Room room;

  void onStudentItemPressed(Student student) {
    showBottomSheetMenuModal(student.fullName, null, true, [
      AppModalBottomSheetMenuGroup(
        title: appLocalizations!.admin_manage_contact,
        items: [
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_online_chat,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            icon: const Icon(FluentIcons.send_24_regular),
            onPressed: () {},
          ),
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_sms,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            icon: const Icon(FluentIcons.chat_24_regular),
            onPressed: () {
              _makePhoneCall(appLocalizations!
                  .admin_manage_rooms_detail_students_sms_welcome_template(student.id!, student.fullName));
            },
          ),
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_call,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            icon: const Icon(FluentIcons.call_24_regular),
            onPressed: () {
              _makePhoneCall("tel:${student.id!}");
            },
          ),
        ],
      ),
      AppModalBottomSheetMenuGroup(
        title: appLocalizations!.admin_manage_rooms_detail_students_parent +
            (student.parentPhoneNumber == null || student.parentPhoneNumber!.isEmpty
                ? " (${appLocalizations!.admin_manage_rooms_detail_students_parent_empty})"
                : ""),
        items: [
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_sms,
              style: TextStyle(
                color: (student.parentPhoneNumber == null || student.parentPhoneNumber!.isEmpty)
                    ? Colors.black.withOpacity(0.25)
                    : Colors.black.withOpacity(0.5),
              ),
            ),
            icon: Icon(
              FluentIcons.chat_24_regular,
              color: (student.parentPhoneNumber == null || student.parentPhoneNumber!.isEmpty)
                  ? Colors.black.withOpacity(0.25)
                  : Colors.black.withOpacity(0.55),
            ),
            onPressed: (student.parentPhoneNumber == null || student.parentPhoneNumber!.isEmpty)
                ? null
                : () {
                    _makePhoneCall(appLocalizations!
                        .admin_manage_rooms_detail_students_sms_parent_welcome_template(student.id!, student.fullName));
                  },
          ),
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_call,
              style: TextStyle(
                color: (student.parentPhoneNumber == null || student.parentPhoneNumber!.isEmpty)
                    ? Colors.black.withOpacity(0.25)
                    : Colors.black.withOpacity(0.5),
              ),
            ),
            icon: Icon(
              FluentIcons.call_24_regular,
              color: (student.parentPhoneNumber == null || student.parentPhoneNumber!.isEmpty)
                  ? Colors.black.withOpacity(0.25)
                  : Colors.black.withOpacity(0.5),
            ),
            onPressed: (student.parentPhoneNumber == null || student.parentPhoneNumber!.isEmpty)
                ? null
                : () {
                    _makePhoneCall("tel:${student.parentPhoneNumber!}");
                  },
          ),
        ],
      ),
      AppModalBottomSheetMenuGroup(
        title: appLocalizations!.admin_manage_invoice,
        items: [
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_invoices,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            icon: const Icon(FluentIcons.checkmark_circle_24_regular),
            onPressed: () {},
          ),
        ],
      ),
      AppModalBottomSheetMenuGroup(
        title: appLocalizations!.admin_manage_rooms_detail_info,
        items: [
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_change_room,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            icon: const Icon(FluentIcons.arrow_sync_24_regular),
            onPressed: () {
              _changeRoom(student);
            },
          ),
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_view_profile,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            icon: const Icon(FluentIcons.info_24_regular),
            onPressed: () async {
              navigator.pop();
              navigator.push(
                CupertinoPageRoute(
                  builder: (context) => AdminRoomsDetailStudentsAddScreen(
                    building: building,
                    floor: floor,
                    room: room,
                    student: student,
                    previousPageTitle: title,
                  ),
                ),
              );
            },
          ),
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_delete_profile,
              style: TextStyle(color: Colors.black.withOpacity(0.5)),
            ),
            icon: const Icon(FluentIcons.delete_24_regular),
            onPressed: () {
              _deleteStudent(student);
            },
          ),
        ],
      ),
    ]);
  }

  Future<Room> loadRoom() {
    return RoomRepository.loadRoom(building.id!, floor.id!, room.id!);
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      log('launch');
    } else {
      showSnackbar(appLocalizations!.app_toast_error_processing, const Duration(seconds: 3), () {});
    }
  }

  void _deleteStudent(Student student) {
    showConfirmDialog(
      title: appLocalizations!.app_dialog_title_delete,
      body: Text(appLocalizations!.admin_manage_rooms_detail_students_confirm_delete),
      confirmType: DialogConfirmType.submit,
      dismissible: true,
      onSubmit: () async {
        navigator.pop();

        if (await hasConnectivity()) {
          showLoadingDialog();

          StudentRepository.deleteProfile(student).then((value) {
            showSnackbar(appLocalizations!.app_toast_deleted(student.fullName), const Duration(seconds: 5), () {});
          }).catchError((onError) {
            showSnackbar(onError.toString(), const Duration(seconds: 5), () {});
          }).whenComplete(() {
            navigator.pop();
          });
        }

        navigator.pop();
      },
    );
  }

  void _changeRoom(Student student) async {
    if (await hasConnectivity()) {
      // picking room to move to
      navigator
          .push(CupertinoPageRoute(
              builder: (context) => AdminBuildingsScreen(
                    previousPageTitle: title,
                    pickingRoom: true,
                  )))
          .then((value) async {
        if (value != null) {
          final destinationRoom = (value as Room);

          StudentRepository.changeRoom(student, destinationRoom.id!).then((value) {
            showSnackbar(appLocalizations!.admin_manage_rooms_detail_students_toast_moved(destinationRoom.name),
                const Duration(seconds: 5), () {});
          }).catchError((onError) {
            showSnackbar(onError.toString(), const Duration(seconds: 5), () {});
          }).whenComplete(() {});
        }

        navigator.pop();
      });
    } else {
      navigator.pop();
    }
  }

  void onStudentActiveStateChanged(Student student, bool value) async {
    if (await hasConnectivity()) {
      showLoadingDialog();

      StudentRepository.setActiveState(student, value).then((value) {
        // showSnackbar(appLocalizations!.admin_manage_rooms_detail_students_toast_active_state_changed,
        //     const Duration(seconds: 3), () {});
      }).catchError((onError) {
        showSnackbar(onError, const Duration(seconds: 3), () {});
      }).whenComplete(() {
        navigator.pop();
      });
    }
  }
}
