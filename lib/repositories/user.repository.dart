import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/auth.repository.dart';

class UserRepository {
  static final instance = FirebaseFirestore.instance.collection('users');

  static Future<bool> isFirestoreUserExists(User? theUser) async {
    var user = await instance.doc(theUser?.uid).get();
    return user.exists;
  }

  static Future<bool> isFireStoreUserWithPhoneNumberExists(String phoneNumber) async {
    var user = await instance.where('phone_number', isEqualTo: phoneNumber).get();
    return user.size > 0;
  }

  static Future<bool> isFireStoreUserWithPhoneNumberExistsExcept(String phoneNumber, String? except) async {
    var user = await instance.where('phone_number', isEqualTo: phoneNumber, isNotEqualTo: except).get();
    return user.size > 0;
  }

  /// only called when the user is logged in
  static Future<AppUser?> getCurrentFireStoreUser() async {
    var user = await instance.doc(AuthRepository.instance.currentUser?.uid).get();
    return AppUser.fromFireStoreDocument(user);
  }
}
