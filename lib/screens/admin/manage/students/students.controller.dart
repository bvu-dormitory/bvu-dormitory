import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/repositories/student.repository.dart';
import 'package:bvu_dormitory/screens/admin/manage/students/add/students.add.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/students/exports/students.export.screen.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AdminStudentsController extends BaseController {
  AdminStudentsController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  StudentRepository studentRepository = StudentRepository();

  getStudentsQuantity() {
    return studentRepository.getStudentAccountsQuantity();
  }

  getActiveStudentsQuantity() {
    return studentRepository.getActiveStudentAccountsQuantity();
  }

  getAbsentStudentsQuantity() {
    return studentRepository.getAbsentsStudentAccountsQuantity();
  }

  List<AppMenuGroupItem> get menuItems => [
        AppMenuGroupItem(
          title: appLocalizations?.admin_manage_student_menu_add ??
              "admin_manage_student_menu_add",
          icon: AntDesign.adduser,
          onPressed: () {
            navigator.push(
              CupertinoPageRoute(
                builder: (context) =>
                    AdminStudentsAddScreen(previousPageTitle: title),
              ),
            );
          },
        ),
        AppMenuGroupItem(
            title: appLocalizations?.admin_manage_student_menu_export_excel ??
                "admin_manage_student_menu_export_excel",
            icon: AntDesign.export,
            onPressed: () {
              navigator.push(
                CupertinoPageRoute(
                  builder: (context) =>
                      AdminStudentsExportScreen(previousPageTitle: title),
                ),
              );
            }),
      ];
}
