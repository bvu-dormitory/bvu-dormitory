import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum ServiceType {
  continous,
  seperated,
}

extension ServiceTypeName on ServiceType {
  String get name {
    switch (this) {
      case ServiceType.continous:
        return "Tịnh tiến";

      case ServiceType.seperated:
        return "Riêng lẻ";

      default:
        return "";
    }
  }
}

class Service extends FireStoreModel {
  final String name;
  final String unit;
  final int price;
  final List<dynamic>? rooms;
  final ServiceType type;

  Service({
    String? id,
    required this.name,
    required this.price,
    required this.unit,
    required this.type,
    this.rooms,
  }) : super(id: id);

  factory Service.fromFireStoreDocument(DocumentSnapshot snapshot) {
    // log('mapping service, id: ${snapshot.id}');

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    // log(data['price'].toString() + data['price'].runtimeType.toString());

    return Service(
      id: snapshot.id,
      name: data['name'],
      price: data['price'],
      unit: data['unit'],
      rooms: data['rooms'],
      type: ServiceType.values.firstWhere(
        (element) => element.name == data['type'],
        orElse: () => ServiceType.seperated,
      ),
    );
  }

  @override
  Map<String, dynamic> get json => {
        'name': name,
        'price': price,
        'unit': unit,
        'rooms': rooms,
        'type': type.name,
      };
}
