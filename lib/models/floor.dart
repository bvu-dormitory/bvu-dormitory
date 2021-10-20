import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Floor extends FireStoreModel {
  final int order;

  Floor({
    String? id,
    required this.order,
  }) : super(id: id);

  static List<Floor> fromFireStoreStream(
      QuerySnapshot<Map<String, dynamic>> event) {
    return event.docs
        .map(
          (e) => Floor(
            id: e.id,
            order: e['order'],
          ),
        )
        .toList();
  }
}
