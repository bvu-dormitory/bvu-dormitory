import 'package:bvu_dormitory/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemRepository {
  static final instance = FirebaseFirestore.instance;
  static const String collectionPath = "items";

  static Stream<List<ItemCategory>> syncCategories() {
    return instance
        .collection(collectionPath)
        .snapshots()
        .map((event) => event.docs.map((e) => ItemCategory.fromFireStoreDocument(e)).toList());
  }

  static Future<bool> isCategoryNameAlreadyExists(String value) async {
    final names = await instance.collection(collectionPath).where('name', isEqualTo: value).get();
    return names.size > 0;
  }

  static Future<bool> isCategoryNameAlreadyExistsExcept(String value, String except) async {
    final names = await instance
        .collection(collectionPath)
        .where(
          'name',
          isEqualTo: value,
          isNotEqualTo: except,
        )
        .get();
    return names.size > 0;
  }

  static Future addItem(String value) {
    return instance.collection(collectionPath).add({'name': value});
  }

  static Future updateItem(String catregoryId, String value) {
    return instance.collection(collectionPath).doc(catregoryId).set({'name': value});
  }

  static Future delete(ItemCategory category) {
    return instance.collection(collectionPath).doc(category.id!).delete();
  }
}
