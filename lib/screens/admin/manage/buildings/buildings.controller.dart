import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/repositories/building.repository.dart';

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

  // void deleteBuilding(Building item) {
  //   log('deleting building item...');

  //   _buildingRepository.delete(item.id!).then((value) {
  //     Fluttertoast.showToast(
  //       msg: appLocalizations?.app_toast_deleted("\"$item.name\"") ?? 'Đã xóa',
  //     );

  //     Navigator.of(context).pop();
  //   }).catchError((onError) {
  //     showErrorDialog(onError);
  //   });
  // }
}
