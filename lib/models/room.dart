import 'dart:developer';

import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Room extends FireStoreModel {
  final String name;

  Room({
    String? id,
    required this.name,
    DocumentReference? reference,
  }) : super(id: id, reference: reference);

  @override
  Map<String, dynamic> get json => {
        'name': name,
      };

  factory Room.fromFireStoreDocument(DocumentSnapshot e) {
    return Room(
      id: e.id,
      name: e['name'],
      reference: e.reference,
    );
  }
}
