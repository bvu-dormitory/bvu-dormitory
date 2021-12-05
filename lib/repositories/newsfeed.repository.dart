import 'package:bvu_dormitory/models/inform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsFeedRepository {
  static final instance = FirebaseFirestore.instance;
  static const String collectionPath = "newsfeed-messages";

  /// syncing all repair requests in a particular room
  static Stream<List<Inform>> syncAll() {
    return instance
        .collection(collectionPath)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => Inform.fromFireStoreDocument(e)).toList());
  }

  static Future addInform(Inform inform) {
    return instance.collection(collectionPath).add(inform.json);
  }

  static updateInform(Inform inform) {
    return instance.collection(collectionPath).doc(inform.id).set(inform.json);
  }

  static deleteInform(Inform inform) {
    return instance.collection(collectionPath).doc(inform.id).delete();
  }
}
