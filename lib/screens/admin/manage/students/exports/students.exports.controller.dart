import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/student.repository.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:share/share.dart';

class AdminStudentsExportsController extends BaseController {
  AdminStudentsExportsController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  List<AppMenuGroupItem> get menuItems => [
        AppMenuGroupItem(
          title: appLocalizations?.admin_manage_student_menu_export_excel_all ??
              "admin_manage_student_menu_export_excel_all",
          icon: const Icon(FluentIcons.people_24_regular),
          onPressed: exportAllStudents,
        ),
        AppMenuGroupItem(
          title: appLocalizations?.admin_manage_student_menu_export_excel_active ??
              "admin_manage_student_menu_export_excel_active",
          icon: const Icon(AntDesign.Safety),
          onPressed: exportActiveStudents,
        ),
        AppMenuGroupItem(
          title: appLocalizations?.admin_manage_student_menu_export_excel_absent ??
              "admin_manage_student_menu_export_excel_absent",
          icon: const Icon(AntDesign.close),
          onPressed: exportAbsentStudents,
        ),
      ];

  Excel initNewWorkbook() {
    // create new workbook (new excel file)
    var workbook = Excel.createExcel();
    return workbook;
  }

  saveAndShare(QuerySnapshot<Map<String, dynamic>> snapshot, String fileName) async {
    var workbook = initNewWorkbook();
    var firstSheet = workbook['Sheet1'];

    // adding the top most row for showing headers
    firstSheet.appendRow([
      'Mã sinh viên',
      'Đang ở',
      'Số điện thoại',
      'CCCD/CMND',
      'Họ',
      'Tên',
      'Giới tính',
      'Ngày sinh',
      'Quê quán',
      'Ngày nhập',
      'Phụ huynh',
      'Ghi chú',
    ]);

    // íActive cell style
    CellStyle activeCellStyle = CellStyle(horizontalAlign: HorizontalAlign.Center, verticalAlign: VerticalAlign.Center);

    for (var i = 0; i < snapshot.size; ++i) {
      final student = Student.fromFireStoreDocument(snapshot.docs[i]);

      firstSheet.appendRow([
        student.studentIdNumber,
        student.isActive ? '×' : '',
        student.phoneNumber,
        student.citizenIdNumber,
        student.lastName,
        student.firstName,
        student.gender,
        student.birthDate,
        student.hometown,
        student.joinDate,
        student.parentPhoneNumber,
        student.notes,
      ]);

      // styling
      firstSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i)).cellStyle = activeCellStyle;
    }

    // load the file to a bytes array
    final fileBytes = workbook.save();

    if (fileBytes == null || fileBytes.isEmpty) {
      navigator.pop();

      // saving the file to bytes returns nothing
      showSnackbar(
          appLocalizations!.admin_manage_student_menu_export_excel_file_corrupted, const Duration(seconds: 5), () {});

      return;
    }

    // getting the internal storage path
    Directory internalDirectory = await getApplicationDocumentsDirectory();
    String tempPath = internalDirectory.path;
    String filePath = '$tempPath/$fileName';

    log(internalDirectory.listSync().map((e) => e.path).join('\n'));
    log(filePath);

    try {
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      // share the file
      Share.shareFiles([filePath]).then((value) {}).catchError((onError) {
        showSnackbar(onError.toString(), const Duration(seconds: 5), () {});
      });
    } catch (e) {
      showSnackbar(e.toString(), const Duration(seconds: 5), () {});
    } finally {
      navigator.pop();
    }
  }

  void exportAllStudents() {
    showLoadingDialog();

    StudentRepository.getStudentAccountsList().then((value) async {
      if (value.size > 0) {
        saveAndShare(value, 'all_students.xlsx');
      } else {
        showSnackbar(appLocalizations!.admin_manage_student_menu_export_excel_empty, const Duration(seconds: 3), () {});
      }
    }).catchError((onError) {
      showSnackbar(onError.toString(), const Duration(seconds: 3), () {});
    });
  }

  void exportActiveStudents() {}

  void exportAbsentStudents() {}
}
