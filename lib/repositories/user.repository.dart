import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static Future<bool> isUserWithPhoneNumerExists(User? authUser) async {
    var snapshots = await _instance
        .collection('users/managers/data')
        .where('phoneNumber', isEqualTo: authUser?.phoneNumber ?? "")
        .get();

    return Future(() => snapshots.size == 1);
  }
}
