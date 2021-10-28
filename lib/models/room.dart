import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Room extends FireStoreModel {
  final String name;
  final List<dynamic>? studentIdList;

  Room({
    String? id,
    required this.name,
    required this.studentIdList,
  }) : super(id: id);

  static List<Room> fromFireStoreQuery(QuerySnapshot<Map<String, dynamic>> event) {
    return event.docs.map(
      (e) {
        Map<String, dynamic> doc = e.data();

        return Room(
          id: e.id,
          name: doc['name'],
          studentIdList: doc['students'],
        );
      },
    ).toList();
  }

  static Room fromFireStoreDocument(DocumentSnapshot<Map<String, dynamic>> e) {
    Map<String, dynamic> doc = e.data() as Map<String, dynamic>;

    return Room(
      id: e.id,
      name: doc['name'],
      studentIdList: doc['students'],
    );
  }
}
