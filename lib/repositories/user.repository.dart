import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static Future<bool> isUserWithPhoneNumerExists(User? authUser) async {
    var managerSnapshots = await _instance
        .collection('users/managers/data')
        .where('phoneNumber', isEqualTo: authUser?.phoneNumber ?? "")
        .get();

    var studentSnapshots = await _instance
        .collection('users/students/data')
        .where('phoneNumber', isEqualTo: authUser?.phoneNumber ?? "")
        .get();

    return Future(
        () => managerSnapshots.size == 1 || studentSnapshots.size == 1);
  }

  static getByPhoneNumber(String phoneNumber) async {
    var managerUser = await _instance
        .collection('users/managers/data')
        .where('phoneNumner', isEqualTo: phoneNumber)
        .get();

    var studentUser = await _instance
        .collection('users/students/data')
        .where('phoneNumner', isEqualTo: phoneNumber)
        .get();
  }
}
