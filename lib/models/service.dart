import 'dart:developer';

import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Service extends FireStoreModel {
  final String name;
  final String unit;
  final int price;

  Service({
    String? id,
    required this.name,
    required this.price,
    required this.unit,
  }) : super(id: id);

  factory Service.fromFireStoreDocument(DocumentSnapshot snapshot) {
    log('mapping service, id: ${snapshot.id}');

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    // log(data['price'].toString() + data['price'].runtimeType.toString());

    return Service(id: snapshot.id, name: data['name'], price: data['price'], unit: data['unit']);
  }

  Map<String, dynamic> get json => {
        'name': name,
        'price': price,
        'unit': unit,
      };
}
