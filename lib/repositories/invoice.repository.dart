import 'dart:developer';

import 'package:bvu_dormitory/models/invoice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceRepository {
  static final instance = FirebaseFirestore.instance;
  static const collectionPath = 'invoices';

  static Stream<List<Invoice>> syncInvoices() {
    return instance
        .collectionGroup(collectionPath)
        .snapshots()
        .map((event) => event.docs.map((e) => Invoice.fromFireStoreDocument(e)).toList());
  }

  static Stream<List<Invoice>> syncInvoicesInRoom({required DocumentReference roomRef}) {
    return instance
        .collection('invoices')
        .where('room', isEqualTo: roomRef)
        .orderBy('year')
        .orderBy('month')
        .snapshots()
        .map((event) => event.docs.map((e) => Invoice.fromFireStoreDocument(e)).toList());
  }

  /// getting latest invoice of the room
  static Future<Invoice?> getLastestInvoiceInRoom(DocumentReference roomRef) async {
    final lastestInvoiceDoc = await instance
        .collection(collectionPath)
        .where('room', isEqualTo: roomRef)
        .orderBy('year', descending: true)
        .orderBy('month', descending: true)
        .limit(1)
        .get();

    // log('lastest invoices: ' + lastestInvoiceDoc.size.toString());

    // there is no docs matching the above criterias
    if (lastestInvoiceDoc.size == 0) {
      return null;
    }

    // because we limit the above query to 1, so we can only get 1 document
    return Invoice.fromFireStoreDocument(lastestInvoiceDoc.docs[0]);
  }

  static Future addInvoice(Invoice invoice) {
    return instance.collection(collectionPath).add(invoice.json);
  }

  static Future deleteInvoice(Invoice invoice) async {
    return instance.runTransaction((transaction) async {
      final freshInvoice = await transaction.get(invoice.reference!);
      transaction.delete(freshInvoice.reference);
    });
  }
}
