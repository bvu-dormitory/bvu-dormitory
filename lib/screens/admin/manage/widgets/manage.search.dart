import 'package:flutter/material.dart';

class AdminManageSearchBox extends StatefulWidget {
  const AdminManageSearchBox({Key? key}) : super(key: key);

  @override
  _AdminManageSearchBoxState createState() => _AdminManageSearchBoxState();
}

class _AdminManageSearchBoxState extends State<AdminManageSearchBox> {
  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        hintText: 'Tìm kiếm',
      ),
    );
  }
}
