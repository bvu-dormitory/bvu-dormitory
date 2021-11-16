import 'package:bvu_dormitory/base/base.firestore.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ServiceType {
  continous,
  seperated,
}

extension ServiceTypeName on ServiceType {
  String get name {
    switch (this) {
      case ServiceType.continous:
        return "Tịnh tiến";

      case ServiceType.seperated:
        return "Riêng lẻ";

      default:
        return "";
    }
  }
}

class Service extends FireStoreModel {
  final String name;
  final String unit;
  final int price;
  final List<dynamic>? rooms;
  final ServiceType type;

  // these following fields only used for continous services
  final int? oldIndex;
  final int? newIndex;
  final int? discounts;

  Service({
    String? id,
    DocumentReference? reference,
    required this.name,
    required this.price,
    required this.unit,
    required this.type,
    this.rooms,

    // invoice fields
    this.oldIndex,
    this.newIndex,
    this.discounts,
  }) : super(
          id: id,
          reference: reference,
        );

  // use for getting a service from the services collection
  factory Service.fromFireStoreDocument(DocumentSnapshot snapshot) {
    // log('mapping service, id: ${snapshot.id}');
    // log(data['price'].toString() + data['price'].runtimeType.toString());

    return Service(
      id: snapshot.id,
      name: snapshot['name'],
      price: snapshot['price'],
      unit: snapshot['unit'],
      rooms: snapshot['rooms'],
      type: ServiceType.values.firstWhere(
        (element) => element.name == snapshot['type'],
        orElse: () => ServiceType.seperated,
      ),
    );
  }

  // use for getting a service item from invoice.services
  factory Service.fromMap(Map<String, dynamic> dict) {
    return Service(
      name: dict['name'],
      price: dict['price'],
      unit: dict['unit'],
      type: ServiceType.values.firstWhere(
        (element) => element.name == dict['type'],
        orElse: () => ServiceType.seperated,
      ),
      oldIndex: dict['old_index'],
      newIndex: dict['new_index'],
      discounts: dict['discounts'],
    );
  }

  // this is for saving to the 'Services' collection
  @override
  Map<String, dynamic> get json => {
        'name': name,
        'price': price,
        'unit': unit,
        'rooms': rooms,
        'type': type.name,
      };

  // this is for saving to the 'services' field in a specific invoice document
  Map<String, dynamic> get invoiceJson {
    final s = {
      'name': name,
      'price': price,
      'unit': unit,
      'type': type.name,
      'discounts': discounts,
    };

    if (type == ServiceType.continous) {
      s['oldIndex'] = oldIndex;
      s['newIndex'] = newIndex;
    }

    return s;
  }
}

/// this is used for the services in the invocies collection
/// this is seperated from the root Services collection, because services could change their price or name over the time,
/// so we need this sub-collection to keep track of the service price at a certain point
// class InvoiceService extends Service {
//   // these two fields only used for continous services
//   final int? oldIndex;
//   final int? newIndex;
//   final int? discounts;

//   /// no 'rooms' field because we don't need it, this service model is inside an invoice
//   ///  - the invoice is inside only one room at all.

//   InvoiceService({
//     String? id,
//     required String name,
//     required int price,
//     required String unit,
//     required ServiceType type,
//     this.oldIndex,
//     this.newIndex,
//     this.discounts,
//     DocumentReference? reference,
//   }) : super(
//           id: id,
//           name: name,
//           price: price,
//           unit: unit,
//           type: type,
//           reference: reference,
//         );

//   static InvoiceService fromFireStoreDocument(QueryDocumentSnapshot<Map<String, dynamic>> e) {
//     return InvoiceService(
//       id: e.id,
//       reference: e.reference,
//       oldIndex: e['oldIndex'],
//       newIndex: e['newIndex'],
//       discounts: e['discounts'],
//       name: e['name'],
//       price: e['price'],
//       unit: e['unit'],
//       type: ServiceType.values.firstWhere(
//         (element) => element.name == e['type'],
//         orElse: () => ServiceType.seperated,
//       ),
//     );
//   }

//   static InvoiceService fromMap(Map<String, dynamic> dict) {
//     return InvoiceService(
//       oldIndex: dict['oldIndex'],
//       newIndex: dict['newIndex'],
//       discounts: dict['discounts'],
//       name: dict['name'],
//       price: dict['price'],
//       unit: dict['unit'],
//       type: ServiceType.values.firstWhere(
//         (element) => element.name == dict['type'],
//         orElse: () => ServiceType.seperated,
//       ),
//     );
//   }
// }
