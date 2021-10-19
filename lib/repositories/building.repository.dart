import 'package:bvu_dormitory/base/base.firestore.repo.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';

class BuildingRepository extends FireStoreRepository {
  BuildingRepository() : super(collectionPath: 'buildings');

  Stream<List<Building>> syncAll() {
    return self
        .orderBy('order', descending: true)
        .snapshots()
        .map((event) => Building.fromFireStoreStream(event));
  }

  Stream<List<Floor>> syncAllFloors(String buildingId) {
    return self
        .doc(buildingId)
        .collection('floors')
        .orderBy('order')
        .snapshots()
        .map(
          (event) => Floor.fromFireStoreStream(event),
        );
  }

  Stream<List<Room>> syncAllRooms(String buildingId, String floorId) {
    return self
        .doc(buildingId)
        .collection('floors')
        .doc(floorId)
        .collection('rooms')
        .orderBy('name')
        .snapshots()
        .map(
          (event) => Room.fromFireStoreStream(event),
        );
  }
}
