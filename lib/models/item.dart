import 'dart:ffi';

import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// just for showing a type of an item, such as: bed, light bulb...
class ItemCategory extends FireStoreModel {
  final String name;

  ItemCategory({String? id, required this.name}) : super(id: id);

  factory ItemCategory.fromFireStoreDocument(DocumentSnapshot e) {
    return ItemCategory(id: e.id, name: e['name']);
  }
}

// for showing a group of items in the same category, such as: light bulb - type a, light bulb - type b...
class ItemGroup extends FireStoreModel {
  final String name;
  final String providerName;
  final String? providerPhone;

  ItemGroup({
    String? id,
    required this.name,
    required this.providerName,
    this.providerPhone,
  }) : super(id: id);

  factory ItemGroup.fromFireStoreDocument(DocumentSnapshot e) {
    final data = e.data() as Map<String, dynamic>;

    return ItemGroup(
      id: e.id,
      name: data['name'],
      providerName: data['provider_name'],
      providerPhone: data['provider_phone'],
    );
  }

  Map<String, dynamic> get json => {
        'name': name,
        'provider_name': providerName,
        'provider_phone': providerPhone,
      };
}

// for showing a particular item in a ItemGroup
class Item extends FireStoreModel {
  final String name;
  final Float price;
  final DateTime purchaseDate;
  final bool inUse;

  Item({
    String? id,
    required this.name,
    required this.price,
    required this.purchaseDate,
    required this.inUse,
  }) : super(id: id);

  factory Item.fromFireStoreDocument(DocumentSnapshot e) {
    return Item(
      id: e.id,
      name: e['name'],
      price: e['price'],
      purchaseDate: e['purchase_date'],
      inUse: e['using'],
    );
  }
}
