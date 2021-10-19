import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/rooms.detail.controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminRoomsDetailStudents extends StatefulWidget {
  const AdminRoomsDetailStudents({Key? key}) : super(key: key);

  @override
  _AdminRoomsDetailStudentsState createState() =>
      _AdminRoomsDetailStudentsState();
}

class _AdminRoomsDetailStudentsState extends State<AdminRoomsDetailStudents> {
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
          controller.appLocalizations?.admin_manage_student ??
              "admin_manage_student",
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
