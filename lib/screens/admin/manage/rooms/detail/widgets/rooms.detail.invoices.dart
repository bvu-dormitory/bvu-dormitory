import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/rooms.detail.controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminRoomsDetailInvoices extends StatefulWidget {
  const AdminRoomsDetailInvoices({Key? key}) : super(key: key);

  @override
  _AdminRoomsDetailInvoicesState createState() =>
      _AdminRoomsDetailInvoicesState();
}

class _AdminRoomsDetailInvoicesState extends State<AdminRoomsDetailInvoices> {
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
          controller.appLocalizations?.admin_manage_invoice ??
              "admin_manage_invoice",
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
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
