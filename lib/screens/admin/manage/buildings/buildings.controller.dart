import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/repositories/building.repository.dart';

import 'search/buildings.search.screen.dart';

class AdminBuildingsController extends BaseController {
  AdminBuildingsController({
    required BuildContext context,
    required String title,
    this.pickingRoom = false,
  }) : super(context: context, title: title);

  final bool pickingRoom;

  Stream<List<Building>> syncBuildings() {
    return BuildingRepository.syncAll();
  }

  Stream<List<Floor>> syncFloors(String buildingId) {
    return BuildingRepository.syncAllFloors(buildingId);
  }

  void search(String roomName) {
    navigator.push(MaterialPageRoute(
      builder: (context) => AdminBuildingsSearchScreen(previousPageTitle: title),
    ));
  }
}
