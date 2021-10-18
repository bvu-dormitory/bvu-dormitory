import 'dart:developer';

import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/rooms.controller.dart';
import 'package:bvu_dormitory/services/repositories/building.repository.dart';

class AdminRoomsBody extends StatefulWidget {
  const AdminRoomsBody({Key? key}) : super(key: key);

  @override
  _AdminRoomsBodyState createState() => _AdminRoomsBodyState();
}

class _AdminRoomsBodyState extends State<AdminRoomsBody> {
  late AdminRoomsController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<AdminRoomsController>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Building>>(
      stream: controller.syncBuildings(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }

        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   child: Text(
              //     controller.appLocalizations?.admin_manage_rooms_guide ??
              //         "admin_manage_rooms_guide",
              //     style: TextStyle(color: Colors.black.withOpacity(0.75)),
              //   ),
              //   margin: const EdgeInsets.only(left: 5),
              // ),
              // const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    // print(snapshot.data!.elementAt(index).json);
                    return _buildingItem(
                      snapshot.data!.elementAt(index),
                      index == 0,
                      index == (snapshot.data!.length - 1),
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const Center(
          child: CupertinoActivityIndicator(
            radius: 15,
          ),
        );
      },
    );
  }

  _buildingItem(Building item, bool isFirst, bool isLast) {
    return GestureDetector(
      // onLongPress: () {
      //   showCupertinoModalBottomSheet(
      //     context: context,
      //     expand: false,
      //     backgroundColor: Colors.transparent,
      //     builder: (context) => _buildingItemContextMenu(item),
      //   );
      // },
      child: CupertinoButton(
        onPressed: () {},
        // color: Colors.white,
        padding: const EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isFirst ? 10 : 0),
              topRight: Radius.circular(isFirst ? 10 : 0),
              bottomLeft: Radius.circular(isLast ? 10 : 0),
              bottomRight: Radius.circular(isLast ? 10 : 0),
            ),
            border: Border.all(
              color: Colors.grey.withOpacity(0.25),
              width: 0.5,
            ),
          ),
          child: ListTile(
            trailing: const Icon(CupertinoIcons.right_chevron),
            // selected: true,
            title: Text(
              "${controller.appLocalizations?.admin_manage_rooms_building} ${item.name}",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black.withOpacity(0.75),
                fontWeight: FontWeight.w700,
                // fontSize: 20,
              ),
            ),
            subtitle: Text(
              item.descriptions,
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildingItemContextMenu(Building item) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "${controller.appLocalizations?.admin_manage_rooms_building} ${item.name}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: ListTile(
                    leading: const Icon(
                      CupertinoIcons.pencil_outline,
                      size: 20,
                    ),
                    minLeadingWidth: 10,
                    title: Text(
                      controller.appLocalizations?.app_action_edit ??
                          "app_action_edit",
                    ),
                  ),
                  onPressed: () => _showBuildingItemEditModal(item),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: ListTile(
                    leading: const Icon(
                      CupertinoIcons.trash,
                      size: 20,
                      color: Colors.red,
                    ),
                    minLeadingWidth: 10,
                    title: Text(
                      controller.appLocalizations?.app_action_delete ??
                          "app_action_delete",
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  onPressed: () {
                    controller.showConfirmDialog(
                      title: controller
                              .appLocalizations?.app_dialog_title_delete ??
                          "app_dialog_title_delete",
                      confirmType: DialogConfirmType.Submit,
                      onSubmit: () => controller.deleteBuilding(item),
                      body: Text(controller.appLocalizations
                              ?.admin_manage_rooms_confirm_delete_building(
                                  item.name) ??
                          "admin_manage_rooms_confirm_delete_building"),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showBuildingItemEditModal(Building item) {
    var buildingNameController = TextEditingController(text: item.name);
    var buildingDescriptionsController =
        TextEditingController(text: item.descriptions);

    controller.showConfirmDialog(
        title: controller.appLocalizations?.app_dialog_title_update ??
            "app_dialog_title_update",
        confirmType: DialogConfirmType.Update,
        body: Column(
          children: [
            const SizedBox(height: 20),
            CupertinoTextField(
              controller: buildingNameController,
              maxLength: 20,
              prefix: Container(
                width: 50,
                alignment: Alignment.centerLeft,
                child: Text(
                  controller.appLocalizations?.admin_manage_rooms_building ??
                      "admin_manage_rooms_building",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                padding: const EdgeInsets.only(left: 10),
              ),
              style: const TextStyle(fontSize: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ),
            const SizedBox(height: 1),
            CupertinoTextField(
              controller: buildingDescriptionsController,
              maxLength: 20,
              prefix: Container(
                width: 50,
                alignment: Alignment.centerLeft,
                child: Text(
                  controller
                          .appLocalizations?.admin_manage_rooms_descriptions ??
                      "admin_manage_rooms_descriptions",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                padding: const EdgeInsets.only(left: 10),
              ),
              style: const TextStyle(fontSize: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
              ),
            ),
          ],
        ),
        onSubmit: () {
          print('pressed...');
        });
  }
}
