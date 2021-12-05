import 'dart:developer';

import 'package:bvu_dormitory/app/app.logger.dart';
import 'package:bvu_dormitory/app/app.notifications.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/user.repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  static FirebaseAuth get instance => FirebaseAuth.instance;

  /// determining whether the FirebaseAuth user logged in
  static Future<bool> isAuthenticated() async {
    var theUser = await instance.authStateChanges().first;
    log(theUser.toString());
    return Future(() => theUser != null);
  }

  // static Future<bool> isPhoneNumberRegistered(String phoneNumber) {
  //   return UserRepository.isFireStoreUserExists(phoneNumber);
  // }

  /// signing out current logged-in user
  static Future<bool> signOut() async {
    try {
      await instance.signOut();
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  /// getting current user info
  static Future<UserRole?> getCurrentUserRole() async {
    var theUser = await UserRepository.getCurrentFireStoreUser();
    log('FireStore user: ${theUser!.phoneNumber}');
    log('Role: ${theUser.role}');
    return theUser.role;
  }

  /// updating FCM device token to use later
  static updateUserFCMToken() async {
    try {
      var deviceToken = await AppNotifications.instance.getToken();
      var theUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(AuthRepository.instance.currentUser?.phoneNumber)
          .get();

      await theUser.reference.update({
        'fcm_token': deviceToken,
      });
    } catch (e) {
      logger.e(e);
    }
  }
}
