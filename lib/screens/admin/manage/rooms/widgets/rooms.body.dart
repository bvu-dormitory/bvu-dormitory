import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/room.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/rooms.detail.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/rooms.controller.dart';

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
    return StreamBuilder<List<Room>>(
      stream: controller.syncRooms(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
        }

        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return _roomItem(
                snapshot.data!.elementAt(index),
                index == 0,
                index == (snapshot.data!.length - 1),
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

  _roomItem(Room item, bool isFirst, bool isLast) {
    return CupertinoButton(
      onPressed: () {
        if (controller.pickingRoom) {
          controller.navigator.pop(item);
        } else {
          controller.navigator.push(
            CupertinoPageRoute(
              builder: (context) => AdminRoomsDetailScreen(
                previousPageTitle:
                    "${controller.appLocalizations?.admin_manage_building} ${controller.building.name} - #${controller.floor.order}",
                building: controller.building,
                floor: controller.floor,
                room: item,
              ),
            ),
          );
        }
      },
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
          trailing: const Icon(CupertinoIcons.right_chevron, size: 16),
          // selected: true,
          title: Text(
            item.name,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black.withOpacity(0.75),
              fontWeight: FontWeight.w700,
              // fontSize: 20,
            ),
          ),
          subtitle: Container(
            margin: const EdgeInsets.only(top: 10),
            child: StreamBuilder<List<Student>?>(
              stream: RoomRepository.syncStudentsInRoom(item.id!),
              builder: (context, snapshot) {
                return Text(
                  controller.appLocalizations!.admin_manage_rooms_quantity(snapshot.data?.length ?? 0),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    // fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
