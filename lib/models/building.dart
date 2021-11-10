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

  @override
  Map<String, dynamic> get json {
    return {
      'id': id,
      'name': name,
      'descriptions': descriptions,
    };
  }

  factory Building.fromFireStoreDocument(DocumentSnapshot snapshot) {
    return Building(
      id: snapshot.id,
      name: snapshot['name'],
      descriptions: snapshot['descriptions'],
    );
  }
}
