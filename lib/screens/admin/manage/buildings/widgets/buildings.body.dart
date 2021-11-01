import 'dart:developer';

import 'package:bvu_dormitory/models/floor.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/rooms.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:bvu_dormitory/models/building.dart';
import 'package:bvu_dormitory/screens/admin/manage/buildings/buildings.controller.dart';

class AdminBuildingsBody extends StatefulWidget {
  const AdminBuildingsBody({Key? key}) : super(key: key);

  @override
  _AdminBuildingsBodyState createState() => _AdminBuildingsBodyState();
}

class _AdminBuildingsBodyState extends State<AdminBuildingsBody> {
  late AdminBuildingsController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<AdminBuildingsController>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Building>>(
      stream: controller.syncBuildings(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Building> buildings = snapshot.data!;

          return CupertinoScrollbar(
            // isAlwaysShown: true,
            scrollbarOrientation: ScrollbarOrientation.right,
            child: ListView.builder(
              // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              primary: false,
              itemCount: buildings.length,
              itemBuilder: (context, index) => _buildingItem(buildings[index], buildings.length, index),
            ),
          );
        }

        return const Center(
          child: Text(
            'Có lỗi trong quá trình xử lý thông tin.',
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  _buildingItem(Building item, int total, int index) {
    return StreamBuilder<List<Floor>>(
      stream: controller.syncFloors(item.id!),
      builder: (context, snapshot) => ClipRRect(
        borderRadius: index == 0
            ? const BorderRadius.vertical(top: Radius.circular(10))
            : index == total - 1
                ? const BorderRadius.vertical(bottom: Radius.circular(10))
                : const BorderRadius.all(Radius.zero),
        child: Container(
          margin: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            borderRadius: index == 0
                ? const BorderRadius.vertical(top: Radius.circular(10))
                : index == total - 1
                    ? const BorderRadius.vertical(bottom: Radius.circular(10))
                    : const BorderRadius.all(Radius.zero),
          ),
          child: Theme(
            data: ThemeData(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              onExpansionChanged: (value) {},
              childrenPadding: const EdgeInsets.only(bottom: 10),
              initiallyExpanded: false,
              textColor: Colors.blue,
              title: Text(
                "${controller.appLocalizations?.admin_manage_building} ${item.name}",
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
                ),
              ),
              children: _buildingItemFloors(item, snapshot),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildingItemFloors(Building building, AsyncSnapshot<List<Floor>> snapshot) {
    return snapshot.hasData
        ? List.generate(snapshot.data!.length, (index) => _buildingItemFloor(building, snapshot.data!.elementAt(index)))
        : [
            const Text('Empty'),
          ];
  }

  _buildingItemFloor(Building building, Floor floor) {
    return Container(
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
              "${controller.appLocalizations?.admin_manage_floor} ${floor.order}",
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
