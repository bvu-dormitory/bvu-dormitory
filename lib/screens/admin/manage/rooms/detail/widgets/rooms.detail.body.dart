import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/rooms.detail.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminRoomsDetailBody extends StatefulWidget {
  const AdminRoomsDetailBody({Key? key}) : super(key: key);

  @override
  _AdminRoomsDetailBodyState createState() => _AdminRoomsDetailBodyState();
}

class _AdminRoomsDetailBodyState extends State<AdminRoomsDetailBody> {
  late AdminRoomsDetailController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<AdminRoomsDetailController>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        _menuGroup(
          controller.appLocalizations?.admin_manage_rooms_detail_info ??
              "admin_manage_rooms_detail_info",
          controller.infoMenuItems,
        ),
        const SizedBox(height: 30),
        _menuGroup(
          controller.appLocalizations?.admin_manage_contact ??
              "admin_manage_contact",
          controller.messageMenuItems,
        ),
        const SizedBox(height: 30),
        _menuGroup(
          controller.appLocalizations?.admin_manage_invoice ??
              "admin_manage_invoice",
          controller.invoiceMenuItems,
        ),
        const SizedBox(height: 30),
        _menuGroup(
          controller.appLocalizations?.admin_manage_repair ??
              "admin_manage_repair",
          controller.repairMenuItems,
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  _menuGroup(String title, List<AdminRoomMenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: List.generate(
            items.length,
            (index) => _menuItem(
              title: items[index].title,
              icon: items[index].icon,
              onPressed: items[index].onPressed,
              isFirst: index == 0,
              isLast: index == items.length - 1,
            ),
          ),
        ),
      ],
    );
  }

  _menuItem({
    required String title,
    required Icon icon,
    Function? onPressed,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return CupertinoButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed();
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
          leading: icon,
          minLeadingWidth: 10,
          trailing: const Icon(CupertinoIcons.right_chevron, size: 16),
          title: Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black.withOpacity(0.75),
              fontWeight: FontWeight.w400,
              // fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
