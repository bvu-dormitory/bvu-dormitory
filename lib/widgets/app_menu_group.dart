import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:flutter/cupertino.dart';

import 'package:bvu_dormitory/app/constants/app.styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class AppMenuGroupItem {
  String title;
  TextStyle? titleStyle;
  bool hasTrailingArrow;
  Widget? trailing;
  Widget? subTitle;
  Widget? icon;
  void Function()? onPressed;
  void Function()? onLongPressed;
  bool enableContextMenu;
  List<Widget>? contextMenuActions;

  AppMenuGroupItem({
    required this.title,
    this.enableContextMenu = false,
    this.contextMenuActions,
    this.titleStyle,
    this.subTitle,
    this.hasTrailingArrow = true,
    this.icon,
    this.onPressed,
    this.onLongPressed,
    this.trailing,
  });
}

class AppMenuGroup extends StatelessWidget {
  AppMenuGroup({
    Key? key,
    this.title,
    this.titleStyle,
    required this.items,
  }) : super(key: key);

  final String? title;
  final TextStyle? titleStyle;
  final List<AppMenuGroupItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null) ...{
          Text(title!, style: titleStyle ?? AppStyles.getMenuGroupTextStyle(context)),
          const SizedBox(height: 10),
        },
        ...List.generate(items.length, (index) {
          final item = items[index];

          return item.enableContextMenu
              ? CupertinoContextMenu(
                  actions: item.contextMenuActions!,
                  child:
                      _menuItem(context: context, icon: item, isFirst: index == 0, isLast: index == items.length - 1),
                  previewBuilder: (context, animation, child) {
                    return _menuItem(context: context, icon: item, isFirst: true, isLast: true);
                  },
                )
              : _menuItem(context: context, icon: item, isFirst: index == 0, isLast: index == items.length - 1);
        }),
      ],
    );
  }

  _menuItem({
    required AppMenuGroupItem icon,
    bool isFirst = false,
    bool isLast = false,
    required BuildContext context,
  }) {
    final appProvider = context.read<AppController>();

    final border = BorderSide(
      color: AppColor.borderColor(appProvider.appThemeMode),
      width: 0.5,
    );

    return GestureDetector(
      onLongPress: icon.onLongPressed,
      child: CupertinoButton(
        onPressed: () {
          if (icon.onPressed != null) {
            icon.onPressed!();
          }
        },
        padding: const EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColor.borderColor(appProvider.appThemeMode),
              width: appProvider.appThemeMode == ThemeMode.light ? 0.5 : 0.3,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isFirst ? 10 : 0),
              topRight: Radius.circular(isFirst ? 10 : 0),
              bottomLeft: Radius.circular(isLast ? 10 : 0),
              bottomRight: Radius.circular(isLast ? 10 : 0),
            ),
          ),
          child: Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isFirst ? 10 : 0),
              topRight: Radius.circular(isFirst ? 10 : 0),
              bottomLeft: Radius.circular(isLast ? 10 : 0),
              bottomRight: Radius.circular(isLast ? 10 : 0),
            ),
            clipBehavior: Clip.hardEdge,
            child: ListTile(
              tileColor: AppColor.secondaryBackgroundColor(appProvider.appThemeMode),
              leading: icon.icon,
              minLeadingWidth: 10,
              trailing:
                  icon.trailing ?? (icon.hasTrailingArrow ? const Icon(CupertinoIcons.right_chevron, size: 16) : null),
              subtitle: icon.subTitle,
              title: Text(
                icon.title,
                textAlign: TextAlign.left,
                style: icon.titleStyle ??
                    TextStyle(
                      color: AppColor.textColor(appProvider.appThemeMode),
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      // fontSize: 20,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
