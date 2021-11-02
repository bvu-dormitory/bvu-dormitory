import 'dart:developer';

import 'package:bvu_dormitory/models/service.dart';
import 'package:bvu_dormitory/screens/admin/manage/services/add/services.add.screen.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/repositories/service.repository.dart';
import 'package:bvu_dormitory/screens/admin/manage/services/services.controller.dart';

class AdminServicesScreen extends BaseScreen<AdminServicesController> {
  AdminServicesScreen({Key? key, required String previousPageTitle})
      : super(key: key, previousPageTitle: previousPageTitle);

  @override
  AdminServicesController provideController(BuildContext context) {
    return AdminServicesController(context: context, title: AppLocalizations.of(context)!.admin_manage_service);
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Icon(FluentIcons.channel_add_20_regular),
      onPressed: () {
        Navigator.of(context).push(CupertinoPageRoute(
          builder: (_) => AdminServicesAddScreen(
            previousPageTitle: context.read<AdminServicesController>().title,
          ),
        ));
      },
    );
  }

  @override
  Widget body(BuildContext context) {
    final controller = context.read<AdminServicesController>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _serviceList(),
      ),
    );
  }

  _serviceList() {
    final controller = context.read<AdminServicesController>();

    return StreamBuilder<List<Service>>(
      stream: ServiceRepository.syncServices(),
      builder: (context, snapshot) {
        // log(snapshot.toString());

        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
              return const Text('Error');
            }

            if (snapshot.hasData) {
              return _buildServiceList(snapshot.data!);
            } else {
              return Text(controller.appLocalizations!.admin_manage_service_empty);
            }

          default:
            return const Center(child: CupertinoActivityIndicator(radius: 10));
        }
      },
    );
  }

  _buildServiceList(List<Service> data) {
    final controller = context.read<AdminServicesController>();

    return AppMenuGroup(
        items: data.map((service) {
      log(service.id.toString());

      return AppMenuGroupItem(
        title: service.name,
        titleStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        onPressed: () => controller.onServicePressed(service),
        subTitle: Container(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text('${service.price.toString()}đ/${service.unit}'),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList());
  }
}
