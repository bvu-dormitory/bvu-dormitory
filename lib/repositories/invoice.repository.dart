import 'package:bvu_dormitory/models/invoice.dart';
import 'package:bvu_dormitory/models/service.dart';
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
        .snapshots()
        .map((event) => event.docs.map((e) => Invoice.fromFireStoreDocument(e)).toList());
  }

  // static Stream<List<InvoiceService>> syncServicesInInvoice(Invoice invoices) {
  //   return invoices.reference!
  //       .collection('services')
  //       .snapshots()
  //       .map((event) => event.docs.map((e) => InvoiceService.fromFireStoreDocument(e)).toList());
  // }

  /// getting latest invoice of the room
  static Future<Invoice?> getLastestInvoiceInRoom(DocumentReference roomRef) async {
    final lastestInvoiceDoc = await instance
        .collection(collectionPath)
        .where('room', isEqualTo: roomRef)
        .orderBy('year', descending: true)
        .orderBy('month', descending: true)
        .limit(1)
        .get();

    // there is no docs matching the above criterias
    if (lastestInvoiceDoc.size == 0) {
      return null;
    }

    // because we limit the above query to 1, so we can only get 1 document
    final lastestInvoice = Invoice.fromFireStoreDocument(lastestInvoiceDoc.docs[0]);
  }
}
