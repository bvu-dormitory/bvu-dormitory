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

  static Stream<List<ItemGroup>> syncItemGroupsInCategory(String categoryId) {
    return instance
        .collection(collectionPath)
        .doc(categoryId)
        .collection('groups')
        .orderBy('name')
        .snapshots()
        .map((event) => event.docs.map((e) => ItemGroup.fromFireStoreDocument(e)).toList());
  }

  //
  //
  // category manipulation
  static Future<bool> isCategoryNameAlreadyExists({required String value}) async {
    final names = await instance.collection(collectionPath).where('name', isEqualTo: value).get();
    return names.size > 0;
  }

  static Future<bool> isCategoryNameAlreadyExistsExcept({required String value, required String except}) async {
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

  static Future addCategory({required String value}) {
    return instance.collection(collectionPath).add({'name': value});
  }

  static Future updateCategory({required String value, required String categoryId}) {
    return instance.collection(collectionPath).doc(categoryId).set({'name': value});
  }

  static Future deleteCategory({required String id}) {
    return instance.collection(collectionPath).doc(id).delete();
  }

  //
  //
  // group manipulation
  static isGroupNameAlreadyExists({required String value, required String categoryId}) async {
    final names = await instance
        .collection(collectionPath)
        .doc(categoryId)
        .collection('groups')
        .where('name', isEqualTo: value)
        .get();
    return names.size > 0;
  }

  static isGroupNameAlreadyExistsExcept(
      {required String value, required String except, required String categoryId}) async {
    final names = await instance
        .collection(collectionPath)
        .doc(categoryId)
        .collection('groups')
        .where('name', isEqualTo: value, isNotEqualTo: except)
        .get();
    return names.size > 0;
  }

  static Future addGroup({required ItemGroup value, required String parentCategoryId}) {
    return instance.collection(collectionPath).doc(parentCategoryId).collection('groups').add(value.json);
  }

  static Future updateGroup({required ItemGroup value, required String parentCategoryId}) {
    return instance.collection(collectionPath).doc(parentCategoryId).collection('groups').doc(value.id).set(value.json);
  }

  static Future deleteGroup({required String id, required String parentCategoryId}) {
    return instance.collection(collectionPath).doc(parentCategoryId).collection('groups').doc(id).delete();
  }
}
