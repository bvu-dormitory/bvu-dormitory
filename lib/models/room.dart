import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Room extends FireStoreModel {
  final String name;

  Room({
    String? id,
    required this.name,
  }) : super(id: id);

  static List<Room> fromFireStoreStream(
      QuerySnapshot<Map<String, dynamic>> event) {
    return event.docs
        .map(
          (e) => Room(
            id: e.id,
            name: e['name'],
          ),
        )
        .toList();
  }
}
