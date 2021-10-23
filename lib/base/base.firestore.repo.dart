import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebaseRepository<T extends FireStoreModel> {
  late final CollectionReference<Map<String, dynamic>> self;
  final fsInstance = FirebaseFirestore.instance;
  final stInstance = FirebaseStorage.instance;

  FirebaseRepository({required String collectionPath}) {
    self = FirebaseFirestore.instance.collection(collectionPath);
  }
}
