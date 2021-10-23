import 'package:bvu_dormitory/base/base.firestore.repo.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:flutter/foundation.dart';

class StudentRepository extends FirebaseRepository {
  StudentRepository() : super(collectionPath: "users");

  Future<int?> getStudentAccountsQuantity() async {
    try {
      final students = await self
          .where('role', isEqualTo: describeEnum(UserRole.student))
          .get();
      return students.size;
    } catch (e) {
      Future.error(e);
    }
  }

  Future<int?> getActiveStudentAccountsQuantity() async {
    try {
      final students = await self
          .where('role', isEqualTo: describeEnum(UserRole.student))
          .where('active', isEqualTo: true)
          .get();
      return students.size;
    } catch (e) {
      Future.error(e);
    }
  }

  Future<int?> getAbsentsStudentAccountsQuantity() async {
    try {
      final students = await self
          .where('role', isEqualTo: describeEnum(UserRole.student))
          .where('active', isEqualTo: false)
          .get();
      return students.size;
    } catch (e) {
      Future.error(e);
    }
  }
}
