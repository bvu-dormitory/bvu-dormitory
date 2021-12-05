import 'dart:developer';

import 'package:bvu_dormitory/models/repair_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

class RepairRequestRepository {
  static final instance = FirebaseFirestore.instance;
  static const String collectionPath = "repair-requests";

  /// syncing all repair requests in a particular room
  static Stream<List<RepairRequest>> syncAllInRoom({required DocumentReference roomRef}) {
    return instance
        .collection(collectionPath)
        .where('room', isEqualTo: roomRef)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => RepairRequest.fromFireStoreDocument(e)).toList());
  }

  static addRequest({required RepairRequest value}) {
    return instance.collection(collectionPath).add(value.json);
  }

  static updateRequest({required RepairRequest value}) {
    log('updating request...' + value.json.toString());
    return instance.collection(collectionPath).doc(value.id).set(value.json);
  }

  static deleteRequest(RepairRequest theItem) {
    return instance.collection(collectionPath).doc(theItem.id).delete();
  }

  static syncAllNotYetDone() {
    return instance
        .collection(collectionPath)
        .where('done', isEqualTo: false)
        .snapshots()
        .map((event) => event.docs.map((e) => RepairRequest.fromFireStoreDocument(e)).toList());
  }

  static Stream<List<RepairRequest>> countAll() {
    return instance
        .collection(collectionPath)
        .snapshots()
        .map((event) => event.docs.map((e) => RepairRequest.fromFireStoreDocument(e)).toList());
  }
}
