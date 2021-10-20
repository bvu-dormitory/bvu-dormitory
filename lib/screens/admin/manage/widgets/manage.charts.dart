import 'package:bvu_dormitory/screens/admin/manage/manage.controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminManageCharts extends StatefulWidget {
  const AdminManageCharts({Key? key}) : super(key: key);

  @override
  _AdminManageChartsState createState() => _AdminManageChartsState();
}

class _AdminManageChartsState extends State<AdminManageCharts> {
  late AdminManageController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<AdminManageController>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      width: double.infinity,
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
