import 'dart:developer';

import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:bvu_dormitory/base/base.firestore.repo.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingRepository extends FireStoreRepository {
  BuildingRepository() : super(collectionPath: 'buildings');

  Stream<List<Building>> syncAll() {
    return self
        .orderBy('order', descending: true)
        .snapshots()
        .map((event) => Building.fromFireStoreStream(event));
  }

  // adding a new Building item
  Future<DocumentReference<Map<String, dynamic>>> add(Building building) {
    return self.add(building.json);
  }

  // deleting a Building based on its id
  Future<void> delete(String id) {
    return fsInstance.runTransaction((transaction) async {
      DocumentSnapshot freshSnapshot = await transaction.get(self.doc(id));
      transaction.delete(freshSnapshot.reference);
    }, timeout: const Duration(seconds: 10));
  }

  Future update(
      {required DocumentReference ref, required Building updatedData}) {
    return fsInstance.runTransaction((transaction) async {
      DocumentSnapshot freshSnapshot = await transaction.get(ref);
      transaction.update(freshSnapshot.reference, updatedData.json);
    });
  }
}
