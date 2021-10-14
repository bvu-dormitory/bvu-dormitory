import 'dart:developer';

import 'package:bvu_dormitory/app/app.logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  /// check whether the just logged-in user have data in the "users" collection
  static Future<bool> isUserWithPhoneNumerExists(User? authUser) async {
    var users =
        await _instance.collection('users').doc(authUser?.phoneNumber).get();

    return users.exists;
  }
}
