import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/rooms.detail.controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminRoomsDetailServices extends StatefulWidget {
  const AdminRoomsDetailServices({Key? key}) : super(key: key);

  @override
  _AdminRoomsDetailServicesState createState() =>
      _AdminRoomsDetailServicesState();
}

class _AdminRoomsDetailServicesState extends State<AdminRoomsDetailServices> {
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
        Text(
          controller.appLocalizations?.admin_manage_service ??
              "admin_manage_service",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 200,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.02),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ]),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
