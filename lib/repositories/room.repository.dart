import 'package:bvu_dormitory/base/base.firestore.repo.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/user.repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RoomRepository extends FirebaseRepository {
  static final instance = FirebaseFirestore.instance.collection('buildings');
  RoomRepository() : super(collectionPath: 'buildings');

  Stream<Room> getImages(String buildingId, String floorId, String roomId) {
    return self.doc(buildingId).collection('floors').doc(floorId).collection('rooms').doc(roomId).snapshots().map(
          (event) => Room.fromFireStoreDocument(event),
        );
  }

  static Future addStudent(String buildingId, String floorId, String roomId, List<dynamic> oldStudents, Student student) async {
    await UserRepository.addStudent(student);

    oldStudents.add(UserRepository.instance.doc(student.phoneNumber));
    return instance.doc(buildingId).collection('floors').doc(floorId).collection('rooms').doc(roomId).update({'students': oldStudents});
  }
}
