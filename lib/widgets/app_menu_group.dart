import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';

import 'package:bvu_dormitory/app/constants/app.styles.dart';
import 'package:flutter/material.dart';

class AppMenuGroupItem {
  String title;
  TextStyle? titleStyle;
  bool hasTrailingArrow;
  Widget? trailing;
  Widget? subTitle;
  IconData? icon;
  Function? onPressed;
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
    this.trailing,
  });
}

class AppMenuGroup extends StatelessWidget {
  const AppMenuGroup({
    Key? key,
    this.title,
    required this.items,
  }) : super(key: key);

  final String? title;
  final List<AppMenuGroupItem> items;

  @override
  Widget build(BuildContext context) {
    return
        // GridView.count(
        //   shrinkWrap: true,
        //   crossAxisCount: 1,
        //   children: List.generate(items.length, (index) {
        //     final item = items[index];

        //     return item.enableContextMenu
        //         ? CupertinoContextMenu(
        //             actions: item.contextMenuActions!,
        //             child: _menuItem(icon: item, isFirst: index == 0, isLast: index == items.length - 1),
        //             previewBuilder: (context, animation, child) {
        //               return _menuItem(icon: item, isFirst: true, isLast: true);
        //             },
        //           )
        //         : _menuItem(icon: item, isFirst: index == 0, isLast: index == items.length - 1);
        //   }),
        // );
        Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null) ...{
          Text(title!, style: AppStyles.menuGroupTextStyle),
          const SizedBox(height: 10),
        },
        ...List.generate(items.length, (index) {
          final item = items[index];

          return item.enableContextMenu
              ? CupertinoContextMenu(
                  actions: item.contextMenuActions!,
                  child: _menuItem(icon: item, isFirst: index == 0, isLast: index == items.length - 1),
                  previewBuilder: (context, animation, child) {
                    return _menuItem(icon: item, isFirst: true, isLast: true);
                  },
                )
              : _menuItem(icon: item, isFirst: index == 0, isLast: index == items.length - 1);
        }),
        // ListView.builder(
        //     itemCount: items.length,
        //     shrinkWrap: true,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemBuilder: (context, index) {
        //       final item = items[index];
        //       return item.enableContextMenu
        //           ? CupertinoContextMenu(
        //               actions: item.contextMenuActions!,
        //               child: _menuItem(icon: item, isFirst: index == 0, isLast: index == items.length - 1),
        //               previewBuilder: (context, animation, child) {
        //                 return _menuItem(icon: item, isFirst: true, isLast: true);
        //               },
        //             )
        //           : _menuItem(icon: item, isFirst: index == 0, isLast: index == items.length - 1);
        //     }),
      ],
    );
  }

  _menuItem({
    required AppMenuGroupItem icon,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return CupertinoButton(
      onPressed: () {
        if (icon.onPressed != null) {
          icon.onPressed!();
        }
      },
      padding: const EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isFirst ? 10 : 0),
            topRight: Radius.circular(isFirst ? 10 : 0),
            bottomLeft: Radius.circular(isLast ? 10 : 0),
            bottomRight: Radius.circular(isLast ? 10 : 0),
          ),
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          child: ListTile(
            leading: icon.icon != null ? Icon(icon.icon, size: 20) : null,
            minLeadingWidth: 10,
            trailing:
                icon.trailing ?? (icon.hasTrailingArrow ? const Icon(CupertinoIcons.right_chevron, size: 16) : null),
            subtitle: icon.subTitle,
            title: Text(
              icon.title,
              textAlign: TextAlign.left,
              style: icon.titleStyle ??
                  TextStyle(
                    color: Colors.black.withOpacity(0.75),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    // fontSize: 20,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
