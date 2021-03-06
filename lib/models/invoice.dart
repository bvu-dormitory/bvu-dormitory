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

    // log('converting payment:...' + snapshot['payments'].toString());
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
        return 'Chuy???n kho???n';

      default:
        return 'Ti???n m???t';
    }
  }
}

class InvoicePayment {
  final int amount;
  final String studentName;
  // final String studentCitizenId;
  // final String studentPhoneNumber;
  final InvoicePaymentType type;
  final String? notes;
  late final Timestamp timestamp;

  InvoicePayment({
    required this.amount,
    required this.type,
    required this.studentName,
    required this.timestamp,
    // required this.studentCitizenId,
    // required this.studentPhoneNumber,
    this.notes,
  });

  get json => {
        'amount': amount,
        'type': type.name,
        'notes': notes,
        // TODO: when a student moved out, maybe the student's info will not available
        // so we have to duplicate the student info
        'student_name': studentName,
        // 'student_citizen_id': studentCitizenId,
        // 'student_phone_number': studentPhoneNumber,
        'timestamp': timestamp,
      };

  static InvoicePayment fromMap(Map<String, dynamic> s) {
    return InvoicePayment(
      amount: s['amount'],
      studentName: s['student_name'],
      // studentCitizenId: s['student_citizen_id'],
      // studentPhoneNumber: s['student_phone_number'],
      type: InvoicePaymentType.values.firstWhere(
        (element) => describeEnum(element) == s['type'],
        orElse: () => InvoicePaymentType.cash,
      ),
      notes: s['notes'],
      timestamp: s['timestamp'],
    );
  }
}
