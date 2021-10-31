import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/user.repository.dart';

class RoomRepository {
  static final instance = FirebaseFirestore.instance;
  static const String collectionPath = 'buildings';

  // Stream<Room> getImages(String buildingId, String floorId, String roomId) {
  //   return instance.doc(buildingId).collection('floors').doc(floorId).collection('rooms').doc(roomId).snapshots().map(
  //         (event) => Room.fromFireStoreDocument(event),
  //       );
  // }

  /// loading a Room info based on id
  static Future<Room> loadRoom(String buildingId, String floorId, String roomId) async {
    final theRoomDoc = await instance
        .collection(collectionPath)
        .doc(buildingId)
        .collection('floors')
        .doc(floorId)
        .collection('rooms')
        .doc(roomId)
        .get();

    return Room.fromFireStoreDocument(theRoomDoc);
  }

  /// getting all students in a room
  static Future<List<Student>?> getStudentsInRoom(List<dynamic> studentIdList) async {
    log('getting students in room... length: [${studentIdList.length}]');

    final List<Student> results = [];

    for (int i = 0; i < studentIdList.length; ++i) {
      final studentDoc = await studentIdList[i].get();
      // log('studentDoc: ' + studentDoc.data().toString());

      final student = Student.fromFireStoreDocument(studentDoc);
      results.add(student);
    }

    return results;
  }

  /// adding a student to a Room and also the Users collection
  static Future addStudent(
    String buildingId,
    String floorId,
    String roomId,
    List<dynamic> studentIdList,
    Student student,
  ) async {
    // firstly add the student to the Users collection
    await UserRepository.addStudent(student);

    // then, add the student reference to the room
    studentIdList.add(UserRepository.instance.doc(student.phoneNumber));

    final roomRef = instance
        .collection(collectionPath)
        .doc(buildingId)
        .collection('floors')
        .doc(floorId)
        .collection('rooms')
        .doc(roomId);

    return instance.runTransaction((transaction) async {
      // getting newest reference to the document to ensure data is up-to-date
      final DocumentSnapshot freshSnapshot = await transaction.get(roomRef);

      // add a step
      transaction.update(freshSnapshot.reference, {'students': studentIdList});
    }, timeout: const Duration(seconds: 15));
  }

  /// deleting a student from a room and also the Users collection
  static Future deleteStudent(
    String buildingId,
    String floorId,
    String roomId,
    List<dynamic> studentIdList,
    Student student,
  ) async {
    log('deleting student... length: [${studentIdList.length}]');
    for (int i = 0; i < studentIdList.length; ++i) {
      final studentDoc = await (studentIdList[i] as DocumentReference).get();
      log('deleting student... length: [${studentDoc.data().toString()}]');

      if (studentDoc.id == student.id!) {
        // delete the user inside the Users collection

        // put this outside because the below transaction could runs multiple times
        final roomRef = instance
            .collection(collectionPath)
            .doc(buildingId)
            .collection('floors')
            .doc(floorId)
            .collection('rooms')
            .doc(roomId);

        return instance.runTransaction((transaction) async {
          final freshStudentDocSnapshot = await transaction.get(studentIdList[i] as DocumentReference);
          final freshRoomDocSnapshot = await transaction.get(roomRef);

          // delete the student document inside the "users" collection
          transaction.delete(freshStudentDocSnapshot.reference);

          // delete the user reference inside the current room's studentIdList array
          studentIdList.removeAt(i);

          // update the room's studentIdList array
          transaction.update(freshRoomDocSnapshot.reference, {'students': studentIdList});
        }, timeout: const Duration(seconds: 15));
      }
    }

    return Future.error('No matching students found... please try again');
  }

  static Future<bool?> moveStudent({
    required String oldBuildingId,
    required String oldFloorId,
    required String oldRoomId,
    required List<dynamic> oldRoomStudentIdList,
    required String destinationBuildingId,
    required String destinationFloorId,
    required String destinationRoomId,
    required List<dynamic> destinationRoomStudentIdList,
    required Student studentToMove,
  }) async {
    for (int i = 0; i < oldRoomStudentIdList.length; ++i) {
      final studentDoc = await (oldRoomStudentIdList[i] as DocumentReference<Map<String, dynamic>>).get();
      log('moving student: ${studentDoc.exists}');

      if (studentDoc.id == studentToMove.id!) {
        final oldRoomRef = instance
            .collection(collectionPath)
            .doc(oldBuildingId)
            .collection('floors')
            .doc(oldFloorId)
            .collection('rooms')
            .doc(oldRoomId);

        final destinationRoomRef = instance
            .collection(collectionPath)
            .doc(destinationBuildingId)
            .collection('floors')
            .doc(destinationFloorId)
            .collection('rooms')
            .doc(destinationRoomId);

        destinationRoomStudentIdList.add(oldRoomStudentIdList[i]);
        oldRoomStudentIdList.removeAt(i);

        return instance.runTransaction((transaction) async {
          log('retry transaction...');
          final oldRoomFreshRef = await transaction.get(oldRoomRef);
          final destinationRoomFreshRef = await transaction.get(destinationRoomRef);

          // delete the student from the old room
          transaction.update(oldRoomFreshRef.reference, {'students': oldRoomStudentIdList});

          // add the student to the destination room
          transaction.update(destinationRoomFreshRef.reference, {'students': destinationRoomStudentIdList});
        });
      }
    }

    return Future.error('No matching students found... please try again');
  }

  // static Future removeStudent(String buildingId, String floorId, String roomId, List<dynamic> oldStudents, Student student) async {
  //   await UserRepository.addStudent(student);

  //   oldStudents.removeWhere((element) => element)
  //   return instance.doc(buildingId).collection('floors').doc(floorId).collection('rooms').doc(roomId).update({'students': oldStudents});
  // }
}
