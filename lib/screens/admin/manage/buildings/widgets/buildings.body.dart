import 'dart:developer';

import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/repositories/building.repository.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/rooms.screen.dart';
import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/screens/admin/manage/buildings/buildings.controller.dart';

class AdminBuildingsBody extends StatelessWidget {
  const AdminBuildingsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Building>>(
      stream: BuildingRepository.syncAll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Building> buildings = snapshot.data!;
          context.read<AdminBuildingsController>().expansionStates = List.filled(buildings.length, true);
          log('updated buildings...' + context.read<AdminBuildingsController>().expansionStates.length.toString());

          return Consumer<AdminBuildingsController>(
            builder: (context, controller, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ExpansionPanelList(
                  elevation: 0,
                  expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 0),
                  animationDuration: const Duration(milliseconds: 540),
                  expansionCallback: (panelIndex, isExpanded) {
                    controller.updateExpansionStateAt(panelIndex, !controller.expansionStates[panelIndex]);
                  },
                  children: List.generate(buildings.length, (index) {
                    final theBuilding = buildings[index];

                    // each panel represents for a Building
                    return ExpansionPanel(
                      isExpanded: controller.expansionStates[index],
                      canTapOnHeader: true,
                      backgroundColor: AppColor.navigationBackgroundColor(context.read<AppController>().appThemeMode),
                      headerBuilder: (context, isExpanded) {
                        return GestureDetector(
                          onLongPress: () {
                            controller.showBottomSheetMenuModal('title', null, true, []);
                            log('message');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.admin_manage_building + ' ' + theBuilding.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    // color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  theBuilding.descriptions,
                                  style: const TextStyle(
                                      // color: Colors.black.withOpacity(0.5),
                                      ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      // floors of a Building
                      body: StreamBuilder<List<Floor>>(
                        stream: BuildingRepository.syncAllFloors(theBuilding.id!),
                        builder: (context, snapshot) => Column(
                          children: List.generate(snapshot.data?.length ?? 0, (index) {
                            return _buildingItemFloor(
                              context: context,
                              building: theBuilding,
                              floor: snapshot.data!.elementAt(index),
                              isSuffixItem: index == (snapshot.data?.length ?? 0),
                            );
                          }),
                        ),

                        // ListView.builder(
                        //   shrinkWrap: true,
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   itemCount: (snapshot.data?.length ?? 0),
                        //   itemBuilder: (context, index) {
                        //     return _buildingItemFloor(
                        //       context: context,
                        //       building: theBuilding,
                        //       floor: snapshot.data?.elementAt(index),
                        //       isSuffixItem: index == (snapshot.data?.length ?? 0),
                        //     );
                        //   },
                        // ),

                        //  ReorderableListView.builder(
                        //   onReorder: (oldIndex, newIndex) {
                        //     final theFloors = snapshot.data!;
                        //     controller.onFloorOrderChanged(
                        //         buildingId: theBuilding.id!, oldOrder: oldIndex, newOrder: newIndex);
                        //   },
                        //   shrinkWrap: true,
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   itemCount: snapshot.data?.length ?? 0,
                        //   itemBuilder: (context, index) {
                        //     return _buildingItemFloor(context, theBuilding, snapshot.data!.elementAt(index));
                        //   },
                        // ),
                      ),
                    );
                  }),
                ),
              );
            },
          );
        }

        return const Center(
          child: CupertinoActivityIndicator(radius: 10),
        );
      },
    );
  }

  _buildingItemFloor({
    required BuildContext context,
    required Building building,
    required Floor floor,
    bool isSuffixItem = false,
  }) {
    final controller = context.read<AdminBuildingsController>();

    return SizedBox(
      key: Key("${isSuffixItem ? building.id : floor.id}"),
      width: double.infinity,
      child: CupertinoButton(
        padding: const EdgeInsets.only(
          top: 15,
          bottom: 15,
          left: 15,
          right: 20,
        ),
        onPressed: () {
          // navigate to the Rooms screen
          Navigator.of(context)
              .push(
            CupertinoPageRoute(
              builder: (context) => AdminRoomsScreen(
                previousPageTitle: controller.title,
                building: building,
                floor: floor,
                pickingRoom: controller.pickingRoom,
              ),
            ),
          )
              .then((value) {
            if (value != null) {
              Navigator.of(context).pop(value);
            }
          });
        },
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              !isSuffixItem ? "${controller.appLocalizations?.admin_manage_floor} ${floor.order}" : '+',
            ),
            Row(
              children: const [
                Icon(
                  CupertinoIcons.chevron_right,
                  size: 16,
                ),
                SizedBox(width: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
