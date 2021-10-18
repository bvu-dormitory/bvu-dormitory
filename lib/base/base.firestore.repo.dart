import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FireStoreRepository<T extends FireStoreModel> {
  late final CollectionReference<Map<String, dynamic>> self;
  final fsInstance = FirebaseFirestore.instance;

  FireStoreRepository({required String collectionPath}) {
    self = FirebaseFirestore.instance.collection(collectionPath);
  }
}
