import 'package:flutter/material.dart';

class AdminManageSearchBox extends StatefulWidget {
  AdminManageSearchBox({Key? key}) : super(key: key);

  @override
  _AdminManageSearchBoxState createState() => _AdminManageSearchBoxState();
}

class _AdminManageSearchBoxState extends State<AdminManageSearchBox> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Tìm kiếm',
      ),
    );
  }
}
