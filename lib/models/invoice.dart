import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Invoice extends FireStoreModel {
  Invoice({
    String? id,
    required this.cost,
    required this.done,
    required this.date,
    required this.month,
    required this.year,
  }) : super(id: id);

  final int cost;
  final bool done;

  final int date;
  final int month;
  final int year;

  @override
  Map<String, dynamic> get json => {
        'cost': cost,
        'done': done,
        'date': date,
        'month': month,
        'year': year,
      };

  factory Invoice.fromFireStoreDocument(DocumentSnapshot<Object?> snapshot) {
    return Invoice(
      id: snapshot.id,
      done: snapshot['done'],
      cost: snapshot['cost'],
      date: snapshot['date'],
      month: snapshot['month'],
      year: snapshot['year'],
    );
  }
}
