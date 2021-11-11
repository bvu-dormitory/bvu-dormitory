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

  static Stream<List<Invoice>> syncInvoicesInRoom(
      {required String buildingId, required String floorId, required String roomId}) {
    return instance
        .collection('buildings')
        .doc(buildingId)
        .collection('floors')
        .doc(floorId)
        .collection('rooms')
        .doc(roomId)
        .collection('invoices')
        .snapshots()
        .map((event) => event.docs.map((e) => Invoice.fromFireStoreDocument(e)).toList());
  }
}
