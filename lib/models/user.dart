import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum UserRole {
  admin,
  student,
}

class AppUser extends FireStoreModel {
  String name;
  UserRole role;
  String? photoURL;

  AppUser({
    required this.name,
    required this.role,
    this.photoURL,
  });

  factory AppUser.fromFireStoreDocument(DocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map<String, dynamic>;
    return AppUser(
      name: data['name'],
      role: UserRole.values.firstWhere(
        (element) => describeEnum(element) == data['role'],
        orElse: () => UserRole.student,
      ),
      photoURL: data['photoURL'],
    );
  }
}

class Student extends AppUser {
  String? address;
  String? relativePhoneNumber;
  String? citizenIdentityNumber;

  Student({
    required String name,
  }) : super(
          name: name,
          role: UserRole.student,
        );
}
