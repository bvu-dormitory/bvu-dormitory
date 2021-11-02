import 'dart:developer';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/service.dart';
import 'package:bvu_dormitory/repositories/service.repository.dart';
import 'package:bvu_dormitory/screens/admin/manage/services/add/services.add.screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class AdminServicesController extends BaseController {
  AdminServicesController({required BuildContext context, required String title})
      : super(context: context, title: title);

  onServicePressed(Service service) {
    showBottomSheetModal(
      service.name,
      null,
      true,
      [
        AppModalBottomSheetMenuGroup(
          title: appLocalizations!.app_bottom_sheet_menu_general,
          items: [
            AppModalBottomSheetItem(
              label: Text(
                appLocalizations!.admin_manage_service_chart,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
              icon: const Icon(SimpleLineIcons.pie_chart, size: 22),
              onPressed: () {
                // _editService(service);
              },
            ),
          ],
        ),
        AppModalBottomSheetMenuGroup(
          title: appLocalizations!.app_bottom_sheet_menu_actions,
          items: [
            AppModalBottomSheetItem(
              label: Text(
                appLocalizations!.admin_manage_service_edit,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
              icon: const Icon(FluentIcons.compose_24_regular),
              onPressed: () {
                _editService(service);
              },
            ),
            AppModalBottomSheetItem(
              label: Text(
                appLocalizations!.app_action_delete,
                style: const TextStyle(color: Colors.red),
              ),
              icon: const Icon(FluentIcons.delete_24_regular, color: Colors.red),
              onPressed: () {
                _deleteService(service);
              },
            ),
          ],
        ),
      ],
    );
  }

  _deleteService(Service service) async {
    if (await hasConnectivity()) {
      try {
        await ServiceRepository.deleteService(service);
      } catch (e) {
        showSnackbar(e.toString(), const Duration(seconds: 3), () {});
      } finally {
        navigator.pop();
      }
    }
  }

  _editService(Service item) {
    navigator
        .push(CupertinoPageRoute(
      builder: (context) => AdminServicesAddScreen(
        previousPageTitle: title,
        service: item,
      ),
    ))
        .then((value) {
      navigator.pop();
    });
  }
}
