import 'dart:developer';

import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/helpers/extensions/datetime.extensions.dart';
import 'package:bvu_dormitory/models/repair_request.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/repositories/repair_request.repository.dart';
import 'package:bvu_dormitory/repositories/room.repository.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/repairs/rooms.detail.repairs.controller.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:collection/collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:provider/src/provider.dart';
import 'package:tuple/tuple.dart';
import 'repairs.controller.dart';

class AdminRepairsScreen extends BaseScreen<AdminRepairsController> {
  AdminRepairsScreen({Key? key, String? previousPageTitle})
      : super(key: key, previousPageTitle: previousPageTitle, haveNavigationBar: true);

  @override
  AdminRepairsController provideController(BuildContext context) {
    return AdminRepairsController(context: context, title: AppLocalizations.of(context)!.admin_manage_repair);
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _stats(),
              const SizedBox(height: 50),
              _requestsList(),
            ],
          ),
        ),
      ),
    );
  }

  _requestsList() {
    final controller = context.read<AdminRepairsController>();

    return StreamBuilder<List<RepairRequest>>(
      stream: RepairRequestRepository.syncAllNotYetDone(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
        }

        if (snapshot.hasData) {
          return _buildRequestsList(snapshot.data!);
        }

        return const CupertinoActivityIndicator(radius: 10);
      },
    );
  }

  _buildRequestsList(List<RepairRequest> list) {
    final controller = context.read<AdminRepairsController>();

    final groupedItems = groupBy(list, (Object? o) {
      // grouping by room
      return (o as RepairRequest).room;
    });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedItems.length,
      itemBuilder: (context, index) {
        final items = groupedItems.values.toList()[index];
        final groupName = groupedItems.keys.toList()[index];

        return FutureBuilder<Room>(
          future: RoomRepository.loadRoomFromRef(groupName),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
                }

                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: AppMenuGroup(
                      title: AppLocalizations.of(context)!.admin_manage_room + " " + snapshot.data!.name,
                      items: List.generate(items.length, (index) {
                        final theItem = items[index];

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
                              ],
                            ),
                          ),
                          onPressed: () {
                            // reuse the controller from the AdminRoomsDetailRepairsController
                            AdminRoomsDetailRepairsController(context: context, title: "", room: snapshot.data!)
                                .showRequestEditBottomSheet(request: theItem);
                          },
                        );
                      }),
                    ),
                  );
                }

                return const Text('?');

              default:
                return const LinearProgressIndicator(minHeight: 1);
            }
          },
        );
      },
    );
  }

  _stats() {
    final controller = context.read<AdminRepairsController>();

    // Tuple<all requests, waiting requests>
    return StreamBuilder<List<RepairRequest>>(
      stream: RepairRequestRepository.countAll(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log(snapshot.error.toString());
          controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
        }

        if (snapshot.hasData) {
          final theList = snapshot.data!;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.secondaryBackgroundColor(context.read<AppController>().appThemeMode),
                    // color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 0.5,
                      color: AppColor.borderColor(context.read<AppController>().appThemeMode),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        theList.where((element) => element.done).toList().length.toString(),
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.green,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        AppLocalizations.of(context)!.admin_reports_repairs_done,
                        style: TextStyle(color: Colors.green.shade800),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),
              //
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.secondaryBackgroundColor(context.read<AppController>().appThemeMode),
                    // color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 0.5,
                      color: AppColor.borderColor(context.read<AppController>().appThemeMode),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        theList.where((element) => !element.done).toList().length.toString(),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.amber.shade900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        AppLocalizations.of(context)!.admin_reports_repairs_waiting,
                        style: TextStyle(color: Colors.amber.shade800),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return const CupertinoActivityIndicator(radius: 10);
      },
    );
  }
}
