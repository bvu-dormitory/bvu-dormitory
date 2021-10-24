import 'package:bvu_dormitory/screens/admin/manage/students/students.controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminStudentsStats extends StatefulWidget {
  const AdminStudentsStats({Key? key}) : super(key: key);

  @override
  _AdminStudentsStatsState createState() => _AdminStudentsStatsState();
}

class _AdminStudentsStatsState extends State<AdminStudentsStats> {
  late AdminStudentsController controller;
  static const double radius = 10.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<AdminStudentsController>(context);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 25,
      mainAxisSpacing: 25,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: MediaQuery.of(context).size.width / 450,
      children: [
        _totalQuantityChip(context),
        _activeQuantityChip(context),
        _absentQuantityChip(context),
      ],
    );
  }

  _totalQuantityChip(BuildContext context) {
    final controller = context.read<AdminStudentsController>();

    return FutureBuilder<int?>(
      future: controller.getStudentsQuantity(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          controller.showErrorDialog(snapshot.error.toString());
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            // color: Colors.lightBlue.shade50,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [
                Colors.purple.shade100.withOpacity(0.2),
                Colors.teal.withOpacity(0.025),
              ],
            ),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              width: 0.15,
              color: Colors.blue.shade900,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.lightBlue.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${snapshot.data}",
                // "500",
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                controller.appLocalizations?.admin_manage_student_all ??
                    "admin_manage_student_all",
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _activeQuantityChip(BuildContext context) {
    final controller = context.read<AdminStudentsController>();

    return FutureBuilder<int?>(
      future: controller.getActiveStudentsQuantity(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          controller.showErrorDialog(snapshot.error.toString());
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            // color: Colors.lightGreen.shade100,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [
                Colors.lightGreen.withOpacity(0.15),
                Colors.yellow.withOpacity(0.25),
              ],
            ),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              width: 0.15,
              color: Colors.green.shade900,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.lightGreen.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${snapshot.data}",
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                controller.appLocalizations?.admin_manage_student_active ??
                    "admin_manage_student_active",
                style: TextStyle(
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _absentQuantityChip(BuildContext context) {
    final controller = context.read<AdminStudentsController>();

    return FutureBuilder<int?>(
      future: controller.getAbsentStudentsQuantity(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          controller.showErrorDialog(snapshot.error.toString());
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            // color: Colors.yellow.withOpacity(0.25),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [
                Colors.yellow.withOpacity(0.15),
                Colors.redAccent.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              width: 0.15,
              color: Colors.yellow.shade900,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.035),
                blurRadius: 5,
                offset: const Offset(-5, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${snapshot.data}",
                // "500",
                style: TextStyle(
                  color: Colors.yellow.shade900,
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                controller.appLocalizations?.admin_manage_student_absent ??
                    "admin_manage_student_absent",
                style: TextStyle(
                  color: Colors.yellow.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
