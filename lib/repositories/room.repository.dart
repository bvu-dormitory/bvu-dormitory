import 'dart:developer';

import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/user.dart';

class RoomRepository {
  static final instance = FirebaseFirestore.instance;
  static const String collectionPath = 'buildings';

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

  static Future<Room> loadRoomFromRef(DocumentReference roomRef) async {
    final theRoom = await roomRef.get();
    return Room.fromFireStoreDocument(theRoom);
  }

  static Stream<List<Student>> syncStudentsInRoom(String roomId) {
    return instance
        .collection('users')
        .where('room_id', isEqualTo: roomId)
        .snapshots()
        .map((event) => event.docs.map((e) => Student.fromFireStoreDocument(e)).toList());
  }

  static Stream<Room> syncRoom(String buildingId, String floorId, String roomId) {
    return instance
        .collection(collectionPath)
        .doc(buildingId)
        .collection('floors')
        .doc(floorId)
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .map((event) => Room.fromFireStoreDocument(event));
  }
}
