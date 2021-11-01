import 'dart:developer';

import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Room extends FireStoreModel {
  final String name;

  Room({
    String? id,
    required this.name,
  }) : super(id: id);

  static List<Room> fromFireStoreQuery(QuerySnapshot<Map<String, dynamic>> event) {
    return event.docs.map(
      (e) {
        Map<String, dynamic> doc = e.data();

        return Room(
          id: e.id,
          name: doc['name'],
        );
      },
    ).toList();
  }

  static Room fromFireStoreDocument(DocumentSnapshot<Map<String, dynamic>> e) {
    Map<String, dynamic> doc = e.data() as Map<String, dynamic>;
    // log('mapping room...');

    return Room(
      id: e.id,
      name: doc['name'],
    );
  }
}
