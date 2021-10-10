import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  static FirebaseAuth get instance => FirebaseAuth.instance;

  static Future<bool> isAuthenticated() async {
    var theUser = await instance.authStateChanges().first;

    return Future(() => theUser != null);
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
