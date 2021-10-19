import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/rooms.detail.controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminRoomsDetailItems extends StatefulWidget {
  const AdminRoomsDetailItems({Key? key}) : super(key: key);

  @override
  _AdminRoomsDetailItemsState createState() => _AdminRoomsDetailItemsState();
}

class _AdminRoomsDetailItemsState extends State<AdminRoomsDetailItems> {
  late AdminRoomsDetailController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<AdminRoomsDetailController>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          controller.appLocalizations?.admin_manage_item ?? "admin_manage_item",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
