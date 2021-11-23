import 'dart:developer';

import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/screens/student/profile/student.profile.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/helpers/extensions/string.extensions.dart';
import 'package:bvu_dormitory/widgets/app.form.picker.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';

class ProfileController extends BaseController {
  ProfileController({
    required BuildContext context,
    required String title,
    required this.user,
  }) : super(context: context, title: title);

  final AppUser user;

  TextStyle get menuGroupTitleStyle => TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColor.textColor(context.read<AppController>().appThemeMode),
      );

  Color get iconColor => AppColor.mainColor(context.read<AppController>().appThemeMode);

  List<AppMenuGroup> get menuGroups => [
        if (user.role == UserRole.student) ...{
          AppMenuGroup(
            title: appLocalizations!.home_screen_navbar_item_profile,
            titleStyle: menuGroupTitleStyle,
            items: [
              AppMenuGroupItem(
                title: appLocalizations!.admin_manage_rooms_detail_students_view_profile,
                icon: Icon(FluentIcons.info_24_filled, size: 20, color: iconColor),
                onPressed: () {
                  navigator.push(
                    CupertinoPageRoute(
                      builder: (context) {
                        return StudentProfileDetailScreen(student: user as Student, previousPageTitle: title);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        },
        AppMenuGroup(
          title: appLocalizations!.profile_app_settings,
          titleStyle: menuGroupTitleStyle,
          items: [
            AppMenuGroupItem(
              title: appLocalizations!.profile_app_settings_theme,
              icon: Icon(FluentIcons.dark_theme_24_filled, size: 20, color: iconColor),
              onPressed: _showThemePicker,
            ),
            AppMenuGroupItem(
              title: appLocalizations!.profile_app_settings_locale,
              icon: Icon(FluentIcons.local_language_24_filled, size: 20, color: iconColor),
              onPressed: _showLocalePicker,
            ),
          ],
        ),
      ];

  _showThemePicker() {
    final appProvider = context.read<AppController>();

    showCupertinoModalBottomSheet(
      context: context,
      builder: (_) {
        return AppFormPicker(
          type: AppFormPickerFieldType.custom,
          required: true,
          initialValue: describeEnum(appProvider.appThemeMode).toCapitalize(),
          dataList: ThemeMode.values.sublist(1).map((e) => describeEnum(e).toCapitalize()).toList(),
          onSelectedItemChanged: (value) {
            appProvider.changeTheme(
              ThemeMode.values.sublist(1)[value],
            );
          },
        );
      },
    );
  }

  _showLocalePicker() {
    final appProvider = context.read<AppController>();

    showCupertinoModalBottomSheet(
      context: context,
      builder: (_) {
        return AppFormPicker(
          type: AppFormPickerFieldType.custom,
          required: true,
          // initialValue: describeEnum(appProvider.appThemeMode).toCapitalize(),
          dataList: AppLocalizations.supportedLocales.map((e) => e.toString()).toList(),
          onSelectedItemChanged: (value) {},
        );
      },
    );
  }
}
