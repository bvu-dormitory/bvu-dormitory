import 'dart:developer';

import 'package:bvu_dormitory/models/building.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingRepository {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static Stream<Building> listenById({required String id}) {
    return _instance
        .collection('building')
        .doc(id)
        .snapshots()
        .map((event) => Building.fromFireStore(event));
  }

  static update(DocumentReference ref, Building updatedData) {
    _instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnapshot = await transaction.get(ref);
      transaction.update(freshSnapshot.reference, updatedData.json);
    }).then((value) {
      log('[building model updated]');
    }).catchError((onError) {
      log('[error updating Building model]');
    });
  }
}
