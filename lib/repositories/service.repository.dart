import 'dart:developer';

import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRepository {
  static final instance = FirebaseFirestore.instance;
  static const String collectionPath = 'services';

  static Stream<List<Service>> syncServices() {
    return instance.collection(collectionPath).snapshots().map((event) => event.docs
        .map(
          (e) => Service.fromFireStoreDocument(e),
        )
        .toList());
  }

  // services manipulation
  static Future<bool> isServiceAlrealdyExists(String name) async {
    return (await instance.collection(collectionPath).where('name', isEqualTo: name).get()).size != 0;
  }

  static Future<bool> isServiceAlrealdyExistsExcept(String name, String except) async {
    return (await instance
                .collection(collectionPath)
                .where(
                  'name',
                  isEqualTo: name,
                  isNotEqualTo: except,
                )
                .get())
            .size !=
        0;
  }

  static Future<dynamic> setService(Service formValue) {
    if (formValue.id == null) {
      return instance.collection(collectionPath).add(formValue.json);
    }

    log('saving old service: ${formValue.id}');
    return instance.collection(collectionPath).doc(formValue.id).set(formValue.json);
  }

  static Future deleteService(Service service) {
    return instance.collection(collectionPath).doc(service.id!).delete();
  }

  // room manipulation
  static Future assignToRoom(Service service, Building building, Floor floor, Room room) {
    final serviceRef = instance.collection(collectionPath).doc(service.id);

    final roomRef = instance
        .collection('buildings')
        .doc(building.id)
        .collection('floors')
        .doc(floor.id)
        .collection('rooms')
        .doc(room.id);

    return instance.runTransaction((transaction) async {
      final freshService = await transaction.get(serviceRef);
      final freshRoom = await transaction.get(roomRef);

      transaction.update(freshService.reference, {'rooms': (service.rooms ?? [])..add(freshRoom.reference)});
    });
  }

  static Future removeFromRoom(Service service, Building building, Floor floor, Room room) {
    final serviceRef = instance.collection(collectionPath).doc(service.id);

    service.rooms!.removeWhere((element) => (element as DocumentReference).id == room.id);

    return instance.runTransaction((transaction) async {
      final freshService = await transaction.get(serviceRef);
      transaction.update(freshService.reference, {'rooms': (service.rooms ?? [])});
    });
  }
}
