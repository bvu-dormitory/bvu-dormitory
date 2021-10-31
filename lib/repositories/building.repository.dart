import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';

class BuildingRepository {
  static final instance = FirebaseFirestore.instance.collection('buildings');

  /// Realtime syncing all buildings
  static Stream<List<Building>> syncAll() {
    return instance.orderBy('order', descending: true).snapshots().map((event) => Building.fromFireStoreStream(event));
  }

  /// Realtime syncing all floor in a building
  static Stream<List<Floor>> syncAllFloors(String buildingId) {
    return instance
        .doc(buildingId)
        .collection('floors')
        .orderBy('order')
        .snapshots()
        .map((event) => Floor.fromFireStoreStream(event));
  }

  /// Realtime syncing all rooms in a floor
  static Stream<List<Room>> syncAllRooms(String buildingId, String floorId) {
    return instance
        .doc(buildingId)
        .collection('floors')
        .doc(floorId)
        .collection('rooms')
        .orderBy('name')
        .snapshots()
        .map((event) => Room.fromFireStoreQuery(event));
  }

  // Stream<Room> syncRoom(String buildingId, String floorId, String roomId) {
  //   return self
  //       .doc(buildingId)
  //       .collection('floors')
  //       .doc(floorId)
  //       .collection('rooms')
  //       .doc(roomId)
  //       .snapshots()
  //       .map((event) => Room.fromFireStoreDocument(event));
  // }

}
