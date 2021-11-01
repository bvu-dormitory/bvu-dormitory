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

  /// getting all students in a room
  static Future<List<Student>?> getStudentsInRoom(String roomId) async {
    final list = await instance.collection('users').where('room_id', isEqualTo: roomId).get();
    return list.docs.map((e) => Student.fromFireStoreDocument(e)).toList();
  }

  static Stream<List<Student>> syncStudentsInRoom(String roomId) {
    return instance
        .collection('users')
        .where('room_id', isEqualTo: roomId)
        .snapshots()
        .map((event) => event.docs.map((e) => Student.fromFireStoreDocument(e)).toList());
  }
}
