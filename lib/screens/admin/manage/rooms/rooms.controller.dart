import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/building.repository.dart';

class AdminRoomsController extends BaseController {
  Building building;
  Floor floor;

  AdminRoomsController({
    required BuildContext context,
    required String title,
    required this.building,
    required this.floor,
    this.pickingRoom = false,
  }) : super(context: context, title: title);

  final bool pickingRoom;

  Stream<List<Room>> syncRooms() {
    return BuildingRepository.syncAllRooms(building.id!, floor.id!);
  }
}
