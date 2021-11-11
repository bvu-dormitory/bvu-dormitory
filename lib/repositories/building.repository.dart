import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';

class BuildingRepository {
  static final instance = FirebaseFirestore.instance;
  static const String collectionPath = 'buildings';

  /// Realtime syncing all buildings
  static Stream<List<Building>> syncAll() {
    return instance
        .collection(collectionPath)
        .snapshots()
        .map((event) => event.docs.map((e) => Building.fromFireStoreDocument(e)).toList());
  }

  /// Realtime syncing all floor in a building
  static Stream<List<Floor>> syncAllFloors(String buildingId) {
    return instance
        .collection(collectionPath)
        .doc(buildingId)
        .collection('floors')
        .orderBy('order')
        .snapshots()
        .map((event) => event.docs.map((e) => Floor.fromFireStoreDocument(e)).toList());
  }

  static Future<bool> isBuildingNameAlreadyExists({required String value}) async {
    final buildings = await instance.collection(collectionPath).where('name', isEqualTo: value).get();
    return buildings.size > 0;
  }

  static Future<bool> isBuildingNameAlreadyExistsExcept({required String value, required String except}) async {
    final buildings =
        await instance.collection(collectionPath).where('name', isEqualTo: value, isNotEqualTo: except).get();
    return buildings.size > 0;
  }

  static Future addBuilding({required Building value}) {
    return instance.collection(collectionPath).add(value.json);
  }

  static Future updateBuilding({required Building value}) {
    return instance.collection(collectionPath).doc(value.id!).set(value.json);
  }

  // static void changeFloorOrder({String buildingId, int oldOrder, int newOrder}) {

  // }
}
