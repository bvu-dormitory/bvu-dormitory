import 'dart:developer';

import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:bvu_dormitory/models/service.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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

    log('converting payment:...' + snapshot['payments'].toString());
    final paymentsList = (snapshot['payments'] as List<dynamic>).map((s) {
      log('a');
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

  /// total bill cost to pay
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

  /// total payments amount
  int get paid {
    return payments.isEmpty ? 0 : payments.map((e) => e.amount).reduce((value, element) => value + element);
  }
}

enum InvoicePaymentType {
  cash,
  ebanking,
}

extension InvoicePaymentTypeName on InvoicePaymentType {
  String get name {
    switch (this) {
      case InvoicePaymentType.ebanking:
        return 'Chuyển khoản';

      default:
        return 'Tiền mặt';
    }
  }
}

class InvoicePayment {
  final int amount;
  final List<Student> students;
  final InvoicePaymentType type;
  final String? notes;

  InvoicePayment({
    required this.amount,
    required this.students,
    required this.type,
    this.notes,
  });

  get json => {
        'amount': amount,
        'type': type.name,
        'notes': notes,
        // TODO: when a student moved out, maybe the student's info will not available
        'students': students.map((e) => e.reference),
      };

  static InvoicePayment fromMap(Map<String, dynamic> s) {
    return InvoicePayment(
      amount: s['amount'],
      students: s['students'],
      type: InvoicePaymentType.values.firstWhere(
        (element) => describeEnum(element) == s['type'],
        orElse: () => InvoicePaymentType.cash,
      ),
      notes: s['notes'],
    );
  }
}
