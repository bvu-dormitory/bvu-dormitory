import 'package:bvu_dormitory/models/room.dart';

class Floor {
  final int? id;
  final List<Room> rooms;

  Floor({
    required this.id,
    required this.rooms,
  });
}
