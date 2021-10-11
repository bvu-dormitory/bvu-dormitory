import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserRoles {
  SuperAdmin,
  Admin,
  Student,
}

class UserRole {
  String name;

  UserRole({required this.name});
}

class AppUser {
  String name;
  String phoneNumber;
  String? photoURL;
  UserRole? role;

  AppUser({
    required this.name,
    required this.phoneNumber,
    this.photoURL,
    this.role,
  });

  factory AppUser.fromFireStore(QueryDocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map<String, dynamic>;
    return AppUser(
      name: data['name'],
      phoneNumber: data['phoneNumber'],
      photoURL: data['photoURL'],
      role: data['role'],
    );
  }
}

class Student extends AppUser {
  String? address;
  String? relativePhoneNumber;
  String? citizenIdentityNumber;

  Student({required String name, required String phoneNumber})
      : super(name: name, phoneNumber: phoneNumber);
}
