import 'dart:ffi';

import 'package:bvu_dormitory/base/base.firestore.model.dart';

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
}
