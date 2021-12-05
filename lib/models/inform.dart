import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Inform extends FireStoreModel {
  final String title;
  final String content;
  Timestamp timestamp;

  Inform({
    required this.title,
    required this.content,
    required this.timestamp,
    String? id,
  }) : super(id: id);

  @override
  Map<String, dynamic> get json => {
        'title': title,
        'content': content,
        'timestamp': timestamp,
      };

  factory Inform.fromFireStoreDocument(DocumentSnapshot snapshot) {
    return Inform(
      id: snapshot.id,
      title: snapshot['title'],
      content: snapshot['content'],
      timestamp: snapshot['timestamp'],
    );
  }
}
