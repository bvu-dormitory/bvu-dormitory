import 'package:bvu_dormitory/models/floor.dart';
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

  static Stream<List<Room>> syncRooms({required Floor floor}) {
    return instance
        .doc(floor.reference!.path)
        .collection('rooms')
        .orderBy('name')
        .snapshots()
        .map((event) => event.docs.map((e) => Room.fromFireStoreDocument(e)).toList());
  }

  static Future<Room> loadRoomFromRef(DocumentReference roomRef) async {
    final theRoom = await roomRef.get();
    return Room.fromFireStoreDocument(theRoom);
  }

  static Stream<List<Student>> syncStudentsInRoom(Room room) {
    return instance
        .collection('users')
        .where('room', isEqualTo: room.reference)
        .snapshots()
        .map((event) => event.docs.map((e) => Student.fromFireStoreDocument(e)).toList());
  }

  static isRoomNameAlreadyExists({required String value}) {}

  static isRoomNameAlreadyExistsExcept({required String value, required String except}) {}

  static addRoom({required String value}) {}

  static updateRoom({required String value, required String roomId}) {}

  static Future<int> getActiveStudentsQuantity(DocumentReference<Object?> documentReference) async {
    return (await instance
            .collection('users')
            .where(
              'room',
              isEqualTo: documentReference.path,
            )
            .where('active', isEqualTo: true)
            .get())
        .size;
  }
}
