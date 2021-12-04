import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RepairRequest extends FireStoreModel {
  final Timestamp timestamp;
  final String reason;
  final String? notes;
  final DocumentReference room;
  bool done;

  RepairRequest({
    required this.timestamp,
    required this.reason,
    required this.room,
    this.done = false,
    String? id,
    this.notes,
  }) : super(id: id);

  @override
  Map<String, dynamic> get json => {
        'reason': reason,
        'notes': notes,
        'timestamp': timestamp,
        'room': room,
        'done': done,
      };

  static RepairRequest fromFireStoreDocument(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return RepairRequest(
      id: e.id,
      timestamp: e['timestamp'],
      reason: e['reason'],
      room: e['room'],
      done: e['done'],
      notes: e['notes'],
    );
  }
}
