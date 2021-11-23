import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/helpers/extensions/string.extensions.dart';
import 'package:bvu_dormitory/widgets/app.form.picker.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProfileController extends BaseController {
  ProfileController({required BuildContext context, required String title}) : super(context: context, title: title);

  TextStyle get menuGroupTitleStyle => TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black.withOpacity(0.5),
      );

  List<AppMenuGroup> get menuGroups => [
        AppMenuGroup(
          title: appLocalizations!.home_screen_navbar_item_profile,
          titleStyle: menuGroupTitleStyle,
          items: [
            AppMenuGroupItem(
              title: appLocalizations!.admin_manage_rooms_detail_students_view_profile,
              icon: Icon(FluentIcons.info_24_filled, size: 20, color: Colors.blue.shade800),
            ),
          ],
        ),
        AppMenuGroup(
          title: appLocalizations!.profile_app_settings,
          titleStyle: menuGroupTitleStyle,
          items: [
            AppMenuGroupItem(
              title: appLocalizations!.profile_app_settings_theme,
              icon: Icon(FluentIcons.dark_theme_24_filled, size: 20, color: Colors.blue.shade800),
              onPressed: _showThemePicker,
            ),
            AppMenuGroupItem(
              title: appLocalizations!.profile_app_settings_locale,
              icon: Icon(FluentIcons.local_language_24_filled, size: 20, color: Colors.blue.shade800),
            ),
          ],
        ),
      ];

  _showThemePicker() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (_) {
        return AppFormPicker(
          type: AppFormPickerFieldType.custom,
          required: true,
          initialValue: 'Light',
          dataList: ThemeMode.values.map((e) => describeEnum(e).toCapitalize()).toList(),
          onSelectedItemChanged: (value) {},
        );
      },
    );
  }
}
