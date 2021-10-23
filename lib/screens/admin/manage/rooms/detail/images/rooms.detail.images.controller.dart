import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/room.repository.dart';
import 'package:flutter/material.dart';

class RoomImage {
  final String url;

  RoomImage(this.url);
}

class AdminRoomsDetailImagesController extends BaseController {
  AdminRoomsDetailImagesController({
    required BuildContext context,
    required String title,
    required this.building,
    required this.floor,
    required this.room,
  }) : super(context: context, title: title);

  final RoomRepository roomRepository = RoomRepository();

  final Building building;
  final Floor floor;
  final Room room;
}
