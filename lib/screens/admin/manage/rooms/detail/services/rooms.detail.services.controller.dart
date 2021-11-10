import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/service.dart';
import 'package:bvu_dormitory/repositories/service.repository.dart';

class AdminRoomsDetailServicesController extends BaseController {
  AdminRoomsDetailServicesController({
    required BuildContext context,
    required String title,
    required this.building,
    required this.floor,
    required this.room,
  }) : super(context: context, title: title);

  final Building building;
  final Floor floor;
  final Room room;

  onStudentActiveStateChanged(Service service, bool value) async {
    showLoadingDialog();
    log('message');

    try {
      if (value) {
        // await RoomRepository.attachServices(building, floor, room, service);
        ServiceRepository.assignToRoom(service, building, floor, room);
      } else {
        // await RoomRepository.detachService(building, floor, room, service);
        ServiceRepository.removeFromRoom(service, building, floor, room);
      }
    } on FirebaseException catch (e) {
      log(e.code);
      switch (e.code) {
        case 'deadline-exceeded':
          showSnackbar(appLocalizations!.app_error_timeout, const Duration(seconds: 3), () {});
          showSnackbar(e.toString(), const Duration(seconds: 15), () {});
          break;
        default:
      }
    } catch (e) {
      log(e.runtimeType.toString());
      showSnackbar(e.toString(), const Duration(seconds: 15), () {});
    } finally {
      navigator.pop();
    }
  }
}
