import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/room.repository.dart';
import 'package:bvu_dormitory/repositories/user.repository.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'student.room.controller.dart';

class StudentRoomScreen extends BaseScreen<StudentRoomController> {
  StudentRoomScreen({Key? key, String? previousPageTitle})
      : super(key: key, previousPageTitle: previousPageTitle, haveNavigationBar: false);

  @override
  StudentRoomController provideController(BuildContext context) {
    return StudentRoomController(
      context: context,
      title: AppLocalizations.of(context)!.admin_manage_room,
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
    );

    return SafeArea(
      top: false,
      child: StreamBuilder<Student>(
        stream: UserRepository.getCurrentFireStoreStudentStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                _roomHeader(snapshot.data!),
                _roomBody(snapshot.data!),
              ],
            );
          }

          return const CupertinoActivityIndicator(radius: 10);
        },
      ),
    );
  }

  _roomHeader(Student student) {
    _appNameSection() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Image.asset('lib/assets/icons/buildings.png', width: 20),
              ),
              const SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.app_name,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const CircleAvatar(
            backgroundColor: Colors.amber,
            radius: 20,
            backgroundImage: AssetImage('lib/assets/icons/default-user.png'),
          ),
        ],
      );
    }

    _nameSection(Student student) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<Room>(
                  future: RoomRepository.loadRoomFromRef(student.room!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SelectableText(
                        AppLocalizations.of(context)!.admin_manage_room + ' ' + snapshot.data!.name + ".",
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      );
                    }

                    return const CupertinoActivityIndicator(radius: 10);
                  },
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Flexible(
                      child: SelectableText(
                        AppLocalizations.of(context)!.admin_manage_welcome + ' ' + student.fullName,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('👋', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
          ),
          // const CircleAvatar(
          //   backgroundColor: Colors.amber,
          //   radius: 20,
          //   backgroundImage: AssetImage('lib/assets/icons/default-user.png'),
          // ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        // color: Colors.blue.shade800,
        // color: Colors.white,
        gradient: AppColor.mainAppBarGradientColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 20,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _appNameSection(),
          const SizedBox(height: 30),
          _nameSection(student),
        ],
      ),
    );
  }

  _roomBody(Student student) {
    return FutureBuilder<Room>(
      future: RoomRepository.loadRoomFromRef(student.room!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: _roomBodyGrid(snapshot.data!),
          );
        }

        return const CupertinoActivityIndicator(radius: 10);
      },
    );
  }

  _roomBodyGrid(Room room) {
    return Container();
  }
}
