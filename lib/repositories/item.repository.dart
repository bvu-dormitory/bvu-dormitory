import 'package:bvu_dormitory/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemRepository {
  static final instance = FirebaseFirestore.instance;
  static const String collectionPath = "items";

  static Stream<List<ItemCategory>> syncCategories() {
    return instance
        .collection(collectionPath)
        .orderBy('name')
        .snapshots()
        .map((event) => event.docs.map((e) => ItemCategory.fromFireStoreDocument(e)).toList());
  }

  static syncItemGroupsInCategory(String categoryId) {
    return instance
        .collection(collectionPath)
        .doc(categoryId)
        .collection('groups')
        .orderBy('name')
        .snapshots()
        .map((event) => event.docs.map((e) => ItemCategory.fromFireStoreDocument(e)).toList());
  }

  static Future<bool> isCategoryNameAlreadyExists({required String value, String? categoryId}) async {
    final names = await (categoryId == null
            ? instance.collection(collectionPath).where('name', isEqualTo: value)
            : instance.collection(collectionPath).doc(categoryId).collection('groups').where('name', isEqualTo: value))
        .get();
    return names.size > 0;
  }

  static Future<bool> isCategoryNameAlreadyExistsExcept(
      {required String value, required String except, String? categoryId}) async {
    final names = await (categoryId == null
            ? instance.collection(collectionPath).where(
                  'name',
                  isEqualTo: value,
                  isNotEqualTo: except,
                )
            : instance.collection(collectionPath).doc(categoryId).collection('groups').where(
                  'name',
                  isEqualTo: value,
                  isNotEqualTo: except,
                ))
        .get();
    return names.size > 0;
  }

  static Future addItem({required String value, String? parentCategoryId}) {
    return parentCategoryId == null
        ? instance.collection(collectionPath).add({'name': value})
        : instance.collection(collectionPath).doc(parentCategoryId).collection('groups').add({'name': value});
  }

  static Future updateItem({required String value, required String categoryId, String? parentCategoryId}) {
    return parentCategoryId == null
        ? instance.collection(collectionPath).doc(categoryId).set({'name': value})
        : instance
            .collection(collectionPath)
            .doc(parentCategoryId)
            .collection('groups')
            .doc(categoryId)
            .set({'name': value});
  }

  static Future delete({required String id, String? parentCategoryId}) {
    return parentCategoryId == null
        ? instance.collection(collectionPath).doc(id).delete()
        : instance.collection(collectionPath).doc(parentCategoryId).collection('groups').doc(id).delete();
  }
}
