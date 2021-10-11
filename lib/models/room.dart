import 'package:bvu_dormitory/models/item.dart';
import 'package:bvu_dormitory/models/service.dart';
import 'package:bvu_dormitory/models/user.dart';

class Room {
  final String? id;
  final String name;
  final int price;
  final List<Item> items;
  final List<Service> services;
  final List<Student> students;

  Room({
    this.id,
    required this.name,
    required this.price,
    required this.items,
    required this.services,
    required this.students,
  });
}
