import 'dart:developer';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/services/repositories/building.repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminRoomsController extends BaseController {
  BuildingRepository get _buildingRepository => BuildingRepository();

  AdminRoomsController({required BuildContext context})
      : super(context: context);

  Stream<List<Building>> syncBuildings() {
    return _buildingRepository.syncAll();
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
