import 'dart:developer';

import 'package:bvu_dormitory/base/base.firestore.repo.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/user.repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingRepository extends FirebaseRepository {
  BuildingRepository() : super(collectionPath: 'buildings');

  Stream<List<Building>> syncAll() {
    return self.orderBy('order', descending: true).snapshots().map((event) => Building.fromFireStoreStream(event));
  }

  Stream<List<Floor>> syncAllFloors(String buildingId) {
    return self.doc(buildingId).collection('floors').orderBy('order').snapshots().map((event) => Floor.fromFireStoreStream(event));
  }

  Stream<List<Room>> syncAllRooms(String buildingId, String floorId) {
    return self
        .doc(buildingId)
        .collection('floors')
        .doc(floorId)
        .collection('rooms')
        .orderBy('name')
        .snapshots()
        .map((event) => Room.fromFireStoreQuery(event));
  }

  static Future<List<Student>?> getStudentsInRoom(List<dynamic> studentIdList) async {
    print(studentIdList);
    log('getting students in room... length: [${studentIdList.length}]');

    try {
      final List<Student> result = [];

      for (int i = 0; i < studentIdList.length; ++i) {
        final studentDoc = await (studentIdList[i] as DocumentReference).get();
        log('studentDoc: ' + studentDoc.data().toString());

        final student = Student.fromFireStoreDocument(studentDoc);
        result.add(student);
      }

      return result;
    } catch (e) {
      print('error getting students...' + e.toString());
      return null;
    }
  }
}
