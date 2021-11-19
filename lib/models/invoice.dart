import 'dart:developer';

import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:bvu_dormitory/models/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Invoice extends FireStoreModel {
  Invoice({
    String? id,
    DocumentReference? reference,
    required this.createdDate,
    required this.month,
    required this.year,
    required this.room,
    required this.services,
    required this.payments,
    this.notes,
  }) : super(id: id, reference: reference);

  final int year;
  final int month;
  final String createdDate;
  final DocumentReference room;
  final String? notes;

  final List<Service> services;
  final List<InvoicePayment> payments;

  @override
  Map<String, dynamic> get json => {
        'created_date': createdDate,
        'services': services.map((e) => e.invoiceJson).toList(),
        'payments': payments.map((e) => e.json).toList(),
        'month': month,
        'year': year,
        'room': room,
        'notes': notes,
      };

  factory Invoice.fromFireStoreDocument(DocumentSnapshot<Object?> snapshot) {
    final servicesList = (snapshot['services'] as List<dynamic>).map((s) {
      return Service.fromMap(s as Map<String, dynamic>);
    }).toList();

    final paymentsList = (snapshot['payments'] as List<dynamic>).map((s) {
      return InvoicePayment.fromMap(s as Map<String, dynamic>);
    }).toList();

    return Invoice(
      id: snapshot.id,
      reference: snapshot.reference,
      services: servicesList,
      payments: paymentsList,
      createdDate: snapshot['created_date'],
      month: snapshot['month'],
      year: snapshot['year'],
      room: snapshot['room'],
      notes: snapshot['notes'],
    );
  }

  int get total {
    return services.map((e) {
      if (e.type == ServiceType.seperated) {
        return e.price - (e.discounts ?? 0);
      }

      final oldIndex = e.oldIndex ?? 0;
      final newIndex = e.newIndex ?? 0;

      return (e.price * (newIndex - oldIndex)) - (e.discounts ?? 0);
    }).reduce((value, element) => value + element);
  }
}

class InvoicePayment {
  get json => {};

  static InvoicePayment fromMap(Map<String, dynamic> s) {
    return InvoicePayment();
  }
}
