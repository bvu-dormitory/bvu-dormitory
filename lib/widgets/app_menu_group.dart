import 'package:flutter/cupertino.dart';

import 'package:bvu_dormitory/app/constants/app.styles.dart';
import 'package:flutter/material.dart';

class AppMenuGroupItem {
  String title;
  IconData icon;
  Function? onPressed;

  AppMenuGroupItem({required this.title, required this.icon, this.onPressed});
}

class AppMenuGroup extends StatelessWidget {
  const AppMenuGroup({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  final String title;
  final List<AppMenuGroupItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppStyles.menuGroupTextStyle),
        const SizedBox(height: 10),
        Column(
          children: List.generate(
            items.length,
            (index) => _menuItem(
              icon: items[index],
              isFirst: index == 0,
              isLast: index == items.length - 1,
            ),
          ),
        ),
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
            color: Colors.grey.withOpacity(0.25),
            width: 0.5,
          ),
        ),
        child: ListTile(
          leading: Icon(icon.icon, size: 20),
          minLeadingWidth: 10,
          trailing: const Icon(CupertinoIcons.right_chevron, size: 16),
          title: Text(
            icon.title,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black.withOpacity(0.75),
              fontWeight: FontWeight.w400,
              fontSize: 15,
              // fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
