import 'package:bvu_dormitory/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class StudentRepository {
  static final instance = FirebaseFirestore.instance;
  static const collectionPath = 'users';

  static Future<QuerySnapshot<Map<String, dynamic>>> getStudentAccountsList() async {
    final students =
        await instance.collection(collectionPath).where('role', isEqualTo: describeEnum(UserRole.student)).get();
    return students;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getActiveStudentAccountsList() async {
    final students = await instance
        .collection(collectionPath)
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
        .collection(collectionPath)
        .where('role', isEqualTo: describeEnum(UserRole.student))
        .where(
          'active',
          isEqualTo: false,
        )
        .get();

    return students;
  }

  static Future<void> setStudent(Student student) {
    return instance.collection(collectionPath).doc(student.id).set(student.json);
  }

  static Future changeRoom(Student student, String destinationRoomId) {
    return setStudent(student..roomId = destinationRoomId);
  }

  static Future deleteProfile(Student student) {
    return instance.collection(collectionPath).doc(student.id).delete();
  }

  /// set the 'active' state of a student
  static Future setActiveState(Student student, bool isActive) {
    final studentRef = instance.collection(collectionPath).doc(student.id);

    return instance.runTransaction((transaction) async {
      final freshStudentRef = await transaction.get(studentRef);

      transaction.update(freshStudentRef.reference, {'active': isActive});
    });
  }
}
