import 'dart:ffi';

import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemCategory extends FireStoreModel {
  final String name;

  ItemCategory({String? id, required this.name}) : super(id: id);

  factory ItemCategory.fromFireStoreDocument(DocumentSnapshot e) {
    return ItemCategory(id: e.id, name: e['name']);
  }
}

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
