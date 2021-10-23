import 'package:bvu_dormitory/base/base.firestore.repo.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RoomRepository extends FirebaseRepository {
  RoomRepository() : super(collectionPath: 'buildings');

  Stream<Room> getImages(String buildingId, String floorId, String roomId) {
    return self
        .doc(buildingId)
        .collection('floors')
        .doc(floorId)
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .map(
          (event) => Room.fromFireStoreDocument(event),
        );
  }
}
