import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/service.dart';
import 'package:bvu_dormitory/repositories/service.repository.dart';
import 'package:bvu_dormitory/screens/admin/manage/services/add/services.add.screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminServicesController extends BaseController {
  AdminServicesController({required BuildContext context, required String title})
      : super(context: context, title: title);

  List<Widget> getServiceItemContextMenu(Service item) {
    return [
      CupertinoContextMenuAction(
        child: Text(
          appLocalizations!.admin_manage_service_edit,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailingIcon: FluentIcons.edit_16_regular,
        onPressed: () => _editService(item),
      ),
      const SizedBox(height: 1),
      CupertinoContextMenuAction(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              appLocalizations!.app_action_delete,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        isDestructiveAction: true,
        trailingIcon: FluentIcons.delete_24_regular,
        onPressed: () => _deleteService(item),
      ),
    ];
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
