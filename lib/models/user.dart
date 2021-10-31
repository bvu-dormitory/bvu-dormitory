import 'dart:developer';

import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum UserRole {
  admin,
  student,
}

extension UserRoleExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.admin:
        {
          return "admin";
        }
      case UserRole.student:
        {
          return "Nữ";
        }
    }
  }
}

enum UserGender {
  male,
  female,
}

extension UserGenderExtension on UserGender {
  String get name {
    switch (this) {
      case UserGender.male:
        {
          return "Nam";
        }
      case UserGender.female:
        {
          return "Nữ";
        }
    }
  }
}

class AppUser extends FireStoreModel {
  String firstName;
  String lastName;
  UserRole role;
  String? photoURL;

  // document id is also phone number
  String? get phoneNumber => id;
  String get fullName => "$lastName $firstName";

  AppUser({
    required this.firstName,
    required this.lastName,
    required this.role,
    required String id,
    this.photoURL,
  }) : super(id: id);

  factory AppUser.fromFireStoreDocument(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return AppUser(
      id: snapshot.id,
      firstName: data['first_name'],
      lastName: data['last_name'],
      role: UserRole.values.firstWhere(
        (element) => describeEnum(element) == data['role'],
        orElse: () => UserRole.student,
      ),
      photoURL: data['photo_url'],
    );
  }
}

class Student extends AppUser {
  bool isActive;
  String gender;
  String hometown;
  String? notes;

  String? parentPhoneNumber;
  String citizenIdNumber;
  String? studentIdNumber;

  DateTime birthDate;
  DateTime joinDate;
  DateTime? outDate;

  Student({
    required String id,
    required String firstName,
    required String lastName,
    required this.isActive,
    required this.gender,
    required this.hometown,
    required this.birthDate,
    required this.joinDate,
    required this.citizenIdNumber,
    this.outDate,
    this.notes,
    this.studentIdNumber,
    this.parentPhoneNumber,
  }) : super(id: id, firstName: firstName, lastName: lastName, role: UserRole.student);

  static fromFireStoreDocument(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    // log('parsing...');
    // log('active:' + data['active'].toString());

    final student = Student(
      id: snapshot.id,
      isActive: data['active'].toString() == "active" ? true : false,
      firstName: data['first_name'],
      lastName: data['last_name'],
      gender: data['gender'],
      hometown: data['hometown'],
      birthDate: _getDateFromString(data['birth_date'])!,
      joinDate: _getDateFromString(data['join_date'])!,
      // outDate: _getDateFromString(data['out_date']),
      notes: data['notes'],
      studentIdNumber: data['student_id'],
      citizenIdNumber: data['citizen_id'],
      parentPhoneNumber: data['parent_phone'],
    );

    // log('parsing done...');
    return student;
  }

  static DateTime? _getDateFromString(String dateString) {
    if (dateString == "null") {
      return null;
    }

    final splitted = dateString.split('-');
    return DateTime(int.parse(splitted[2]), int.parse(splitted[1]), int.parse(splitted[0]));
  }

  String _getDateStringValue(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  Map<String, dynamic> get json {
    log(describeEnum(role));

    return {
      'role': describeEnum(role),
      'active': true,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'birth_date': _getDateStringValue(birthDate),
      'hometown': hometown,
      'citizen_id': citizenIdNumber,
      'student_id': studentIdNumber,
      'parent_phone': parentPhoneNumber,
      'join_date': _getDateStringValue(joinDate),
      'out_date': outDate != null ? _getDateStringValue(outDate!) : "",
      'notes': notes,
    };
  }
}
