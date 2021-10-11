import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  static FirebaseAuth get instance => FirebaseAuth.instance;

  /// determining whether the FirebaseAuth user logged in
  static Future<bool> isAuthenticated() async {
    var theUser = await instance.authStateChanges().first;
    print(theUser);
    return Future(() => theUser != null);
  }

  /// getting current user info
  static Future<User?> currentUser() async {
    var theUser = await instance.userChanges().first;
    return theUser;
  }

  // send a 6 digits OTP code to the given @phoneNumber
  static Future verifyPhoneNumber(String phoneNumber) {
    return instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (error) {},
      codeSent: (verificationId, forceResendingToken) {},
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }
}
