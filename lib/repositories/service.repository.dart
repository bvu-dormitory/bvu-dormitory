import 'dart:developer';

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

  static Future<bool> isServiceAlrealdyExists(String name) async {
    return (await instance.collection(collectionPath).where('name', isEqualTo: name).get()).size != 0;
  }

  static Future<bool> isServiceAlrealdyExistsExcept(String name, String except) async {
    return (await instance
                .collection(collectionPath)
                .where(
                  'name',
                  isNotEqualTo: except,
                  isEqualTo: name,
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
}
