import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Building extends FireStoreModel {
  final String name;
  final String descriptions;

  Building({
    String? id,
    required this.name,
    required this.descriptions,
  }) : super(id: id);

  Map<String, dynamic> get json {
    return {
      'id': id,
      'name': name,
      'descriptions': descriptions,
    };
  }

  factory Building.fromFireStoreDocument(DocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map<dynamic, dynamic>;

    return Building(
      id: snapshot.id,
      name: data['name'],
      descriptions: data['descriptions'],
    );
  }
}
