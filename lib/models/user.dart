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
          return "student";
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
  String phoneNumber;
  String get fullName => "$lastName $firstName";

  AppUser({
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.phoneNumber,
    this.photoURL,
    String? id,
  }) : super(id: id);

  factory AppUser.fromFireStoreDocument(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    final theRole = UserRole.values.firstWhere(
      (element) => describeEnum(element) == data['role'],
      orElse: () => UserRole.student,
    );

    return theRole == UserRole.admin
        ? AppUser(
            id: snapshot.id,
            firstName: data['first_name'],
            lastName: data['last_name'],
            phoneNumber: data['phone_number'],
            role: UserRole.values.firstWhere(
              (element) => describeEnum(element) == data['role'],
              orElse: () => UserRole.student,
            ),
            photoURL: data['photo_url'],
          )
        : Student.fromFireStoreDocument(snapshot);
  }

  @override
  Map<String, dynamic> get json => {
        'first_name': firstName,
        'last_name': lastName,
        'role': role.name,
        'photo_url': photoURL,
        'phone_number': phoneNumber,
      };
}

class Student extends AppUser {
  DocumentReference? room;

  bool isActive;
  String gender;
  String hometown;
  String? notes;

  String? parentPhoneNumber;
  String citizenIdNumber;
  String? studentIdNumber;

  String birthDate;
  String joinDate;
  String? outDate;

  Student({
    String? id,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required this.isActive,
    required this.gender,
    required this.hometown,
    required this.birthDate,
    required this.joinDate,
    required this.citizenIdNumber,
    this.room,
    this.outDate,
    this.notes,
    this.studentIdNumber,
    this.parentPhoneNumber,
  }) : super(id: id, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, role: UserRole.student);

  static Student fromFireStoreDocument(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    // log('parsing...');
    // log('active:' + data['active'].toString() + data['active'].runtimeType.toString());

    final student = Student(
      id: snapshot.id,
      room: data['room'],
      isActive: data['active'] as bool,
      firstName: data['first_name'],
      lastName: data['last_name'],
      gender: data['gender'],
      hometown: data['hometown'],
      birthDate: data['birth_date'],
      joinDate: data['join_date'],
      outDate: data['out_date'],
      notes: data['notes'],
      studentIdNumber: data['student_id'],
      citizenIdNumber: data['citizen_id'],
      parentPhoneNumber: data['parent_phone'],
      phoneNumber: data['phone_number'],
    );

    // log('parsing done...');
    return student;
  }

  // static DateTime? _getDateFromString(String dateString) {
  //   if (dateString == "null") {
  //     return null;
  //   }

  //   final splitted = dateString.split('-');
  //   return DateTime(int.parse(splitted[2]), int.parse(splitted[1]), int.parse(splitted[0]));
  // }

  // String _getDateStringValue(DateTime date) {
  //   return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  // }

  @override
  Map<String, dynamic> get json => {
        'role': describeEnum(role),
        'room': room,
        'active': true,
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'birth_date': birthDate,
        'hometown': hometown,
        'citizen_id': citizenIdNumber,
        'student_id': studentIdNumber,
        'phone_number': phoneNumber,
        'parent_phone': parentPhoneNumber,
        'join_date': joinDate,
        'out_date': outDate,
        'notes': notes,
      };
}
