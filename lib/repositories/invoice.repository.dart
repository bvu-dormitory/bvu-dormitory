import 'dart:developer';

import 'package:bvu_dormitory/models/invoice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceRepository {
  static final instance = FirebaseFirestore.instance;
  static const collectionPath = 'invoices';

  static Stream<List<Invoice>> syncInvoices() {
    return instance
        .collectionGroup(collectionPath)
        .orderBy('year', descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => Invoice.fromFireStoreDocument(e)).toList());
  }

  static Stream<List<Invoice>> syncInvoicesInRoom({required DocumentReference roomRef}) {
    return instance
        .collection('invoices')
        .where('room', isEqualTo: roomRef)
        .orderBy('year', descending: true)
        .orderBy('month', descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => Invoice.fromFireStoreDocument(e)).toList());
  }

  /// getting latest invoice of the room
  static Stream<Invoice?> getLastestInvoiceInRoom(DocumentReference roomRef) {
    return instance
        .collection(collectionPath)
        .where('room', isEqualTo: roomRef)
        .orderBy('year', descending: true)
        .orderBy('month', descending: true)
        .limit(1)
        .snapshots()
        .map((event) => Invoice.fromFireStoreDocument(event.docs.first));
  }

  static invoiceIsNotDuplicate({required DocumentReference roomRef, required int month, required int year}) async {
    final theInvoice = await instance
        .collection(collectionPath)
        .where('room', isEqualTo: roomRef)
        .where('year', isEqualTo: year)
        .where('month', isEqualTo: month)
        .get();

    return theInvoice.size == 0;
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

  static Future addPayment({required InvoicePayment payment, required Invoice invoice}) {
    invoice.payments.add(payment);
    return instance.collection(collectionPath).doc(invoice.id).set(invoice.json);
  }
}
