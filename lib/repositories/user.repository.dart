import 'package:bvu_dormitory/base/base.firestore.repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/auth.repository.dart';

class UserRepository {
  static final instance = FirebaseFirestore.instance.collection('users');

  /// check whether the just logged-in user have data in the "users" collection
  static Future<bool> isUserWithPhoneNumerExists(User? authUser) async {
    var user = await instance.doc(authUser?.phoneNumber).get();
    return user.exists;
  }

  static Future<DocumentSnapshot> getFireStoreUser(DocumentReference reference) async {
    return reference.get();
  }

  static Future<bool> isFireStoreUserExists(String phoneNumber) async {
    var user = await instance.doc(phoneNumber).get();
    return user.exists;
  }

  static Future<AppUser?> getCurrentFireStoreUser() async {
    var user = await instance.doc(AuthRepository.instance.currentUser?.phoneNumber).get();
    return AppUser.fromFireStoreDocument(user);
  }

  static Stream<AppUser?> getCurrentFireStoreUserStream() {
    return instance
        .doc(AuthRepository.instance.currentUser?.phoneNumber)
        .snapshots()
        .map((user) => AppUser.fromFireStoreDocument(user));
  }

  static Future<void> addStudent(Student student) {
    return instance.doc(student.id).set(student.json);
  }
}
