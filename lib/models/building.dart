import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Building extends FireStoreModel {
  final String name;
  final String descriptions;
  final List<Floor>? floors;

  Building({
    String? id,
    required this.name,
    required this.descriptions,
    required this.floors,
  });

  factory Building.fromFireStore(DocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map<dynamic, dynamic>;

    return Building(
      id: snapshot.id,
      name: data['name'],
      descriptions: data['descriptions'],
      floors: null,
    );
  }

  Map<String, dynamic> get json {
    return {
      'name': name,
      'descriptions': descriptions,
    };
  }
}
