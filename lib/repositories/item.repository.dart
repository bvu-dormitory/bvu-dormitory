import 'dart:developer';

import 'package:bvu_dormitory/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemRepository {
  static final instance = FirebaseFirestore.instance;
  static const String collectionPath = "items";

  //
  //
  // category manipulation
  static Stream<List<ItemCategory>> syncCategories() {
    return instance
        .collection(collectionPath)
        .orderBy('name')
        .snapshots()
        .map((event) => event.docs.map((e) => ItemCategory.fromFireStoreDocument(e)).toList());
  }

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
  static Stream<List<ItemGroup>> syncItemGroupsInCategory(String categoryId) {
    return instance
        .collection(collectionPath)
        .doc(categoryId)
        .collection('groups')
        .orderBy('name')
        .snapshots()
        .map((event) => event.docs.map((e) => ItemGroup.fromFireStoreDocument(e)).toList());
  }

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

  //
  //
  // item detail manipulation
  static Stream<List<Item>> syncItemDetailsInGroup({required String categoryId, required String groupId}) {
    return instance
        .collection(collectionPath)
        .doc(categoryId)
        .collection('groups')
        .doc(groupId)
        .collection('item-details')
        .snapshots()
        .map((event) => event.docs.map((e) => Item.fromFireStoreDocument(e)).toList());
  }

  static isItemCodeAlreadyExists({
    required String code,
    // required String categoryId,
    // required String groupId,
  }) async {
    log('checking item code duplication...');
    final names = await instance.collectionGroup('item-details').where('code', isEqualTo: code).get();
    return names.size > 0;
  }

  static isItemCodeAlreadyExistsExcept({
    required String code,
    required String except,
    // required String categoryId,
    // required String groupId,
  }) async {
    final names =
        await instance.collectionGroup('item-details').where('code', isEqualTo: code, isNotEqualTo: except).get();
    return names.size > 0;
  }

  static Future addItem({
    required Item value,
    required String parentCategoryId,
    required String parentGroupId,
  }) {
    return instance
        .collection(collectionPath)
        .doc(parentCategoryId)
        .collection('groups')
        .doc(parentGroupId)
        .collection('item-details')
        .add(value.json);
  }

  static Future updateItem({
    required Item value,
    required String parentCategoryId,
    required String parentGroupId,
  }) {
    return instance
        .collection(collectionPath)
        .doc(parentCategoryId)
        .collection('groups')
        .doc(parentGroupId)
        .collection('item-details')
        .doc(value.id)
        .set(value.json);
  }

  static Future deleteItem({
    required String id,
    required String parentCategoryId,
    required String parentGroupId,
  }) {
    return instance
        .collection(collectionPath)
        .doc(parentCategoryId)
        .collection('groups')
        .doc(parentGroupId)
        .collection('item-details')
        .doc(id)
        .delete();
  }
}
