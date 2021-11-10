import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Floor extends FireStoreModel {
  final int order;

  Floor({
    String? id,
    required this.order,
  }) : super(id: id);

  factory Floor.fromFireStoreDocument(DocumentSnapshot<Object?> snapshot) {
    return Floor(
      id: snapshot.id,
      order: snapshot['order'],
    );
  }

  @override
  Map<String, dynamic> get json => {
        'order': order,
      };
}
