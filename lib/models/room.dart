import 'dart:developer';

import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Room extends FireStoreModel {
  final String name;
  final DocumentReference? reference;

  Room({
    String? id,
    required this.name,
    this.reference,
  }) : super(id: id);

  factory Room.fromFireStoreDocument(DocumentSnapshot e) {
    Map<String, dynamic> doc = e.data() as Map<String, dynamic>;
    log('mapping room...');

    return Room(
      id: e.id,
      name: doc['name'],
      reference: e.reference,
    );
  }
}
