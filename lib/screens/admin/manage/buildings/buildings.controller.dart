import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/repositories/building.repository.dart';

import 'search/buildings.search.screen.dart';

class AdminBuildingsController extends BaseController {
  BuildingRepository get _buildingRepository => BuildingRepository();

  AdminBuildingsController({
    required BuildContext context,
    required String title,
  }) : super(context: context, title: title);

  Stream<List<Building>> syncBuildings() {
    return _buildingRepository.syncAll();
  }

  Stream<List<Floor>> getFloors(String buildingId) {
    return _buildingRepository.syncAllFloors(buildingId);
  }

  void search(String roomName) {
    navigator.push(MaterialPageRoute(
      builder: (context) =>
          AdminBuildingsSearchScreen(previousPageTitle: title),
    ));
  }
}
