import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/src/provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:bvu_dormitory/helpers/extensions/datetime.extensions.dart';
import 'package:bvu_dormitory/models/repair_request.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/repair_request.repository.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'student.repairs.controller.dart';

class StudentRepairsScreen extends BaseScreen<StudentRepairsController> {
  StudentRepairsScreen({
    Key? key,
    String? previousPageTitle,
    required this.room,
  }) : super(key: key, previousPageTitle: previousPageTitle, haveNavigationBar: true);

  final Room room;

  @override
  StudentRepairsController provideController(BuildContext context) {
    return StudentRepairsController(context: context, title: AppLocalizations.of(context)!.admin_manage_repair);
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: _requestsList(),
        ),
      ),
    );
  }

  _requestsList() {
    final controller = context.read<StudentRepairsController>();

    return StreamBuilder<List<RepairRequest>>(
      stream: RepairRequestRepository.syncAllInRoom(roomRef: room.reference!),
      builder: (context, snapshot) {
        // log(snapshot.toString());

        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              log(snapshot.error.toString());
              controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
              return const Text('Error');
            }

            if (snapshot.hasData) {
              return _buildRequestsList(snapshot.data!);
            } else {
              return Text(controller.appLocalizations!.admin_manage_service_empty);
            }

          default:
            return const Center(child: CupertinoActivityIndicator(radius: 10));
        }
      },
    );
  }

  _buildRequestsList(List<RepairRequest> list) {
    final controller = context.read<StudentRepairsController>();

    // final groupedItems = groupBy(list, (Object? o) {
    //   return (o as Item).reference!.parent.parent!;
    // });

    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: AppMenuGroup(
        items: List.generate(list.length, (index) {
          final theItem = list[index];

          return AppMenuGroupItem(
            title: theItem.reason,
            titleStyle: const TextStyle(fontWeight: FontWeight.w500),
            icon: const Icon(FluentIcons.chat_help_24_regular),
            hasTrailingArrow: false,
            subTitle: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  Text(DateTime.fromMillisecondsSinceEpoch(theItem.timestamp.millisecondsSinceEpoch)
                      .getReadableDateString()),
                  const SizedBox(width: 20),
                  Text(theItem.done
                      ? AppLocalizations.of(context)!.admin_manage_rooms_detail_repair_done
                      : AppLocalizations.of(context)!.admin_manage_rooms_detail_repair_waiting),
                ],
              ),
            ),
            // onPressed: () => controller.showRequestEditBottomSheet(request: theItem),
          );
        }),
      ),
    );
  }
}
