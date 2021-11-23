import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/rooms.detail.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/rooms.controller.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/room.repository.dart';

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
      stream: RoomRepository.syncRooms(floor: controller.floor),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
        }

        if (snapshot.hasData) {
          // return ListView.builder(
          //   shrinkWrap: true,
          //   primary: false,
          //   itemCount: snapshot.data!.length,
          //   itemBuilder: (context, index) {
          //     return _roomItem(
          //       snapshot.data!.elementAt(index),
          //       index == 0,
          //       index == (snapshot.data!.length - 1),
          //     );
          //   },
          // );
          final theList = snapshot.data!;
          return AppMenuGroup(
            items: List.generate(
              theList.length,
              (index) => AppMenuGroupItem(
                title: theList[index].name,
                titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                subTitle: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: StreamBuilder<List<Student>?>(
                    stream: RoomRepository.syncStudentsInRoom(theList[index]),
                    builder: (context, snapshot) {
                      return Text(
                        controller.appLocalizations!.admin_manage_rooms_quantity(snapshot.data?.length ?? 0),
                      );
                    },
                  ),
                ),
                onPressed: () {
                  if (controller.pickingRoom) {
                    controller.navigator.pop(theList[index]);
                  } else {
                    controller.navigator.push(
                      CupertinoPageRoute(
                        builder: (context) => AdminRoomsDetailScreen(
                          previousPageTitle:
                              "${controller.appLocalizations?.admin_manage_building} ${controller.building.name} - #${controller.floor.order}",
                          building: controller.building,
                          floor: controller.floor,
                          room: theList[index],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        }

        return const Center(
          child: CupertinoActivityIndicator(radius: 10),
        );
      },
    );
  }
}
