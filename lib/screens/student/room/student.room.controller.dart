import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/repairs/rooms.detail.repairs.screen.dart';
import 'package:bvu_dormitory/screens/student/home/student.home.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/screens/student/room/services/student.services.screen.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';

import 'invoices/student.invoices.screen.dart';
import 'items/student.items.screen.dart';
import 'members/student.members.screen.dart';
import 'repairs/student.repairs.screen.dart';

class StudentRoomController extends BaseController {
  StudentRoomController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title) {
    student = context.read<StudentHomeController>().student;
  }

  late Room? room;
  late Student student;

  TextStyle get menuGroupTitleStyle => TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColor.textColor(context.read<AppController>().appThemeMode),
      );

  Color get iconColor => AppColor.mainColor(context.read<AppController>().appThemeMode);

  List<AppMenuGroup> get menuGroups => [
        AppMenuGroup(
          title: appLocalizations!.student_room_info,
          titleStyle: menuGroupTitleStyle,
          items: [
            AppMenuGroupItem(
              title: appLocalizations!.admin_manage_service,
              icon: Icon(FluentIcons.wifi_1_24_filled, size: 20, color: iconColor),
              onPressed: room != null
                  ? () {
                      navigator.push(
                        CupertinoPageRoute(
                          builder: (context) => StudentServicesScreen(
                            previousPageTitle: title,
                            room: room!,
                          ),
                        ),
                      );
                    }
                  : null,
            ),
            AppMenuGroupItem(
              title: appLocalizations!.admin_manage_item,
              icon: Icon(FluentIcons.lightbulb_24_filled, size: 20, color: iconColor),
              onPressed: room != null
                  ? () {
                      navigator.push(
                        CupertinoPageRoute(
                          builder: (context) => StudentItemsScreen(
                            previousPageTitle: title,
                            room: room!,
                          ),
                        ),
                      );
                    }
                  : null,
            ),
            AppMenuGroupItem(
              title: appLocalizations!.admin_manage_members,
              icon: Icon(FluentIcons.people_24_filled, size: 20, color: iconColor),
              onPressed: room != null
                  ? () {
                      navigator.push(
                        CupertinoPageRoute(
                          builder: (context) => StudentMembersScreen(
                            previousPageTitle: title,
                            room: room!,
                          ),
                        ),
                      );
                    }
                  : null,
            ),
            AppMenuGroupItem(
              title: appLocalizations!.admin_manage_repair,
              icon: Icon(FluentIcons.chat_help_24_filled, size: 20, color: iconColor),
              onPressed: room != null
                  ? () {
                      navigator.push(
                        CupertinoPageRoute(
                          builder: (context) => AdminRoomsDetailRepairsScreen(
                            previousPageTitle: appLocalizations!.admin_manage_room + " " + room!.name,
                            room: room!,
                          ),
                        ),
                      );
                    }
                  : null,
            ),
          ],
        ),
        AppMenuGroup(
          title: appLocalizations!.admin_manage_invoice,
          titleStyle: menuGroupTitleStyle,
          items: [
            AppMenuGroupItem(
              title: appLocalizations!.admin_manage_invoice_list,
              icon: Icon(FluentIcons.receipt_24_filled, size: 20, color: iconColor),
              onPressed: room != null
                  ? () {
                      navigator.push(
                        CupertinoPageRoute(
                          builder: (context) => StudentInvoicesScreen(
                            previousPageTitle: title,
                            room: room!,
                            student: student,
                          ),
                        ),
                      );
                    }
                  : null,
            ),
            AppMenuGroupItem(
              title: appLocalizations!.student_invoice_history,
              icon: Icon(FluentIcons.history_24_filled, size: 20, color: iconColor),
            ),
          ],
        ),
      ];
}
