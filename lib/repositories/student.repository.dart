import 'package:bvu_dormitory/base/base.firestore.repo.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class StudentRepository {
  static final instance = FirebaseFirestore.instance.collection('users');

  static Future<QuerySnapshot<Map<String, dynamic>>> getStudentAccountsList() async {
    final students = await instance.where('role', isEqualTo: describeEnum(UserRole.student)).get();
    return students;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getActiveStudentAccountsList() async {
    final students = await instance
        .where('role', isEqualTo: describeEnum(UserRole.student))
        .where(
          'active',
          isEqualTo: true,
        )
        .get();

    return students;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getAbsentsStudentAccountsList() async {
    final students = await instance
        .where('role', isEqualTo: describeEnum(UserRole.student))
        .where(
          'active',
          isEqualTo: false,
        )
        .get();

    return students;
  }
}
