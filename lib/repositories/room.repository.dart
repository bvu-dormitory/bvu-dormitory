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

  static Stream<List<Student>> syncStudentsInRoom(String roomId) {
    return instance
        .collection('users')
        .where('room_id', isEqualTo: roomId)
        .snapshots()
        .map((event) => event.docs.map((e) => Student.fromFireStoreDocument(e)).toList());
  }

  static Future detachService(Building building, Floor floor, Room room, Service service) async {
    final roomRef = instance
        .collection(collectionPath)
        .doc(building.id)
        .collection('floors')
        .doc(floor.id)
        .collection('rooms')
        .doc(room.id);

    for (var i = 0; i < room.services!.length; ++i) {
      final roomService = await (room.services![i] as DocumentReference).get();
      if (roomService.id == service.id) {
        return instance.runTransaction((transaction) async {
          final freshRoomRef = await transaction.get(roomRef);

          transaction.update(freshRoomRef.reference, {
            'services': room.services!..removeAt(i),
          });
        }, timeout: const Duration(seconds: 10));
      }
    }

    return Future.error('no_services_found');
  }

  static Future attachServices(Building building, Floor floor, Room room, Service service) {
    final roomRef = instance
        .collection(collectionPath)
        .doc(building.id)
        .collection('floors')
        .doc(floor.id)
        .collection('rooms')
        .doc(room.id);

    final serviceRef = instance.collection('services').doc(service.id);

    return instance.runTransaction((transaction) async {
      final freshRoomRef = await transaction.get(roomRef);
      final freshServiceRef = await transaction.get(serviceRef);

      transaction.update(freshRoomRef.reference, {
        'services': (room.services ?? [])..add(freshServiceRef.reference),
      });
    }, timeout: const Duration(seconds: 10));
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
