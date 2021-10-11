import 'dart:ffi';

class Item {
  final String? id;
  final String name;
  final Float price;
  final DateTime purchase_date;
  final bool inUse;

  Item({
    this.id,
    required this.name,
    required this.price,
    required this.purchase_date,
    required this.inUse,
  });
}
