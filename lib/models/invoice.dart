import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:bvu_dormitory/models/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class InvoiceService extends Service {
//   InvoiceService() : super();

// }

class Invoice extends FireStoreModel {
  Invoice({
    String? id,
    DocumentReference? reference,
    required this.createdDate,
    required this.month,
    required this.year,
    required this.room,
    required this.services,
  }) : super(id: id, reference: reference);

  final int year;
  final int month;
  final String createdDate;
  final DocumentReference room;
  final List<Service> services;

  @override
  Map<String, dynamic> get json => {
        'created_date': createdDate,
        'month': month,
        'year': year,
        'room': room,
      };

  factory Invoice.fromFireStoreDocument(DocumentSnapshot<Object?> snapshot) {
    return Invoice(
      id: snapshot.id,
      services: snapshot['services'].map((Map<String, dynamic> s) => Service.fromMap(s)),
      reference: snapshot.reference,
      createdDate: snapshot['date'],
      month: snapshot['month'],
      year: snapshot['year'],
      room: snapshot['room'],
    );
  }

  int get total {
    return services.map((e) {
      if (e.type == ServiceType.seperated) {
        return e.price - (e.discounts ?? 0);
      }

      final oldIndex = e.oldIndex ?? 0;
      final newIndex = e.newIndex ?? 0;

      return e.price * (newIndex - oldIndex) - (e.discounts ?? 0);
    }).reduce((value, element) => value + element);
  }
}
