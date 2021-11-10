import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FireStoreModel {
  String? id;
  DocumentReference? reference;

  FireStoreModel({
    this.id,
    this.reference,
  });

  // abstract
  Map<String, dynamic> get json;
}
