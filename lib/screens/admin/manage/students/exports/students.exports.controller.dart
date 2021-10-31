import 'dart:developer';

import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/student.repository.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';

class AdminStudentsExportsController extends BaseController {
  AdminStudentsExportsController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  List<AppMenuGroupItem> get menuItems => [
        AppMenuGroupItem(
          title: appLocalizations?.admin_manage_student_menu_export_excel_all ??
              "admin_manage_student_menu_export_excel_all",
          icon: FluentIcons.people_24_regular,
          onPressed: exportAllStudents,
        ),
        AppMenuGroupItem(
          title: appLocalizations?.admin_manage_student_menu_export_excel_active ??
              "admin_manage_student_menu_export_excel_active",
          icon: AntDesign.Safety,
          onPressed: exportActiveStudents,
        ),
        AppMenuGroupItem(
          title: appLocalizations?.admin_manage_student_menu_export_excel_absent ??
              "admin_manage_student_menu_export_excel_absent",
          icon: AntDesign.close,
          onPressed: exportAbsentStudents,
        ),
      ];

  Excel initNewWorkbook() {
    // create new workbook (new excel file)
    var workbook = Excel.createExcel();
    return workbook;
  }

  void exportAllStudents() {
    StudentRepository.getStudentAccountsList().then((value) {
      if (value.size > 0) {
        log("${value.size}");

        var workbook = initNewWorkbook();
        var firstSheet = workbook['Sheet1'];

        value.docs.forEach((element) {
          final student = Student.fromFireStoreDocument(element);
        });
      } else {
        showSnackbar(appLocalizations!.admin_manage_student_menu_export_excel_empty, const Duration(seconds: 3), () {});
      }
    });
  }

  void exportActiveStudents() {}

  void exportAbsentStudents() {}
}
