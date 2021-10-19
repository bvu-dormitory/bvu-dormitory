import 'dart:developer';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/building.repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminRoomsController extends BaseController {
  BuildingRepository get _buildingRepository => BuildingRepository();

  Building building;
  Floor floor;

  AdminRoomsController(
      {required BuildContext context,
      required this.building,
      required this.floor})
      : super(context: context);

  Stream<List<Room>> syncRooms() {
    return _buildingRepository.syncAllRooms(building.id!, floor.id!);
  }
}
