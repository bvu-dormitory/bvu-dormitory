import 'dart:developer';

import 'package:bvu_dormitory/app/app.logger.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/services/repositories/auth.repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  static final _instance = FirebaseFirestore.instance.collection('users');

  /// check whether the just logged-in user have data in the "users" collection
  static Future<bool> isUserWithPhoneNumerExists(User? authUser) async {
    var user = await _instance.doc(authUser?.phoneNumber).get();
    return user.exists;
  }

  static Future<AppUser?> getCurrentFireStoreUser() async {
    try {
      var user = await _instance
          .doc(AuthRepository.instance.currentUser?.phoneNumber)
          .get();

      return AppUser.fromFireStoreDocument(user);
    } catch (e) {
      logger.e(e);
      return null;
    }
  }
}
