import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/src/provider.dart';

class StudentRoomController extends BaseController {
  StudentRoomController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  TextStyle get menuGroupTitleStyle => TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColor.textColor(context.read<AppController>().appThemeMode),
      );

  Color get iconColor => AppColor.mainColor(context.read<AppController>().appThemeMode);

  List<AppMenuGroup> get menuGroups => [
        AppMenuGroup(
          /// TODO: add to app_vi.arb
          title: 'Thông tin phòng',
          titleStyle: menuGroupTitleStyle,
          items: [
            AppMenuGroupItem(
              title: appLocalizations!.admin_manage_service,
              icon: Icon(FluentIcons.wifi_1_24_filled, size: 20, color: iconColor),
            ),
            AppMenuGroupItem(
              title: appLocalizations!.admin_manage_item,
              icon: Icon(FluentIcons.lightbulb_24_filled, size: 20, color: iconColor),
            ),
            AppMenuGroupItem(
              title: appLocalizations!.admin_manage_members,
              icon: Icon(FluentIcons.people_24_filled, size: 20, color: iconColor),
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
            ),
            AppMenuGroupItem(
              title: appLocalizations!.student_invoice_history,
              icon: Icon(FluentIcons.history_24_filled, size: 20, color: iconColor),
            ),
          ],
        ),
      ];
}
