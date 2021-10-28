import 'dart:developer';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/screens/admin/manage/buildings/buildings.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/students/add/rooms.details.students.add.screen.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminRoomsDetailStudentsController extends BaseController {
  AdminRoomsDetailStudentsController({
    required BuildContext context,
    required String title,
    required this.building,
    required this.floor,
    required this.room,
  }) : super(context: context, title: title);

  final Building building;
  final Floor floor;
  final Room room;

  void onStudentItemPressed(Student student) {
    showBottomSheetModal(student.fullName, null, true, [
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
            icon: const Icon(FluentIcons.chat_help_24_regular),
            onPressed: () {},
          ),
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_sms,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            icon: const Icon(FluentIcons.chat_arrow_back_20_regular),
            onPressed: () {
              _makePhoneCall(appLocalizations!.admin_manage_rooms_detail_students_sms_welcome_template(student.id!, student.fullName));
            },
          ),
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_call,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            icon: const Icon(FluentIcons.call_outbound_24_regular),
            onPressed: () {
              _makePhoneCall("tel:${student.id!}");
            },
          ),
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_copy_phone,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            icon: Icon(
              FluentIcons.copy_24_regular,
              color: student.parentPhoneNumber != null ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.25),
            ),
            onPressed: () {
              _copyPhone(student.id!);
            },
          ),
        ],
      ),
      AppModalBottomSheetMenuGroup(
        title: appLocalizations!.admin_manage_rooms_detail_students_parent +
            (student.parentPhoneNumber == null ? " (${appLocalizations!.admin_manage_rooms_detail_students_parent_empty})" : ""),
        items: [
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_sms,
              style: TextStyle(
                color: student.parentPhoneNumber != null ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.25),
              ),
            ),
            icon: Icon(
              FluentIcons.chat_arrow_back_20_regular,
              color: student.parentPhoneNumber != null ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.25),
            ),
            onPressed: student.parentPhoneNumber == null
                ? null
                : () {
                    _makePhoneCall(appLocalizations!.admin_manage_rooms_detail_students_sms_parent_welcome_template(student.id!, student.fullName));
                  },
          ),
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_call,
              style: TextStyle(
                color: student.parentPhoneNumber != null ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.25),
              ),
            ),
            icon: Icon(
              FluentIcons.call_outbound_24_regular,
              color: student.parentPhoneNumber != null ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.25),
            ),
            onPressed: student.parentPhoneNumber == null
                ? null
                : () {
                    _makePhoneCall("tel:${student.parentPhoneNumber!}");
                  },
          ),
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_copy_phone,
              style: TextStyle(
                color: student.parentPhoneNumber != null ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.25),
              ),
            ),
            icon: Icon(
              FluentIcons.copy_24_regular,
              color: student.parentPhoneNumber != null ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.25),
            ),
            onPressed: student.parentPhoneNumber == null
                ? null
                : () {
                    _copyPhone(student.parentPhoneNumber!);
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
              appLocalizations!.admin_manage_rooms_detail_students_view_profile,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            icon: const Icon(FluentIcons.eye_show_24_regular),
            onPressed: () {
              navigator.push(CupertinoPageRoute(
                builder: (context) => AdminRoomsDetailStudentsAddScreen(
                  building: building,
                  floor: floor,
                  room: room,
                  student: student,
                  previousPageTitle: title,
                ),
              ));
            },
          ),
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_change_room,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            icon: const Icon(FluentIcons.send_24_regular),
            onPressed: () {},
          ),
          AppModalBottomSheetItem(
            label: Text(
              appLocalizations!.admin_manage_rooms_detail_students_change_delete_profile,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            icon: const Icon(FluentIcons.delete_24_regular),
            onPressed: () {},
          ),
        ],
      ),
    ]);
  }

  _copyPhone(String phone) {
    log('copying $phone');
    navigator.pop();

    FlutterClipboard.copy(phone).then((value) {
      showSnackbar(appLocalizations!.app_toast_copied, const Duration(seconds: 5), () {});
    }).catchError((onError) {
      showSnackbar(onError.toString(), const Duration(seconds: 5), () {});
    });
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      log('launch');
    } else {
      showSnackbar('Có lỗi trong quá trình xử lý', const Duration(seconds: 3), () {});
    }
  }
}
