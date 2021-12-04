import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/service.dart';
import 'package:bvu_dormitory/repositories/service.repository.dart';
import 'package:bvu_dormitory/widgets/app_menu_group.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'student.services.controller.dart';

class StudentServicesScreen extends BaseScreen<StudentServicesController> {
  StudentServicesScreen({
    Key? key,
    String? previousPageTitle,
    required this.room,
  }) : super(key: key, previousPageTitle: "$previousPageTitle ${room.name}", haveNavigationBar: true);

  final Room room;

  @override
  StudentServicesController provideController(BuildContext context) {
    return StudentServicesController(
      context: context,
      title: AppLocalizations.of(context)!.admin_manage_service,
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder<List<Service>>(
            stream: ServiceRepository.syncServices(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    context
                        .read<StudentServicesController>()
                        .showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
                  }

                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.student_room_services_guide),
                        const SizedBox(height: 20),
                        AppMenuGroup(
                            items: snapshot.data!.map(
                          (service) {
                            return AppMenuGroupItem(
                              title: service.name,
                              titleStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              hasTrailingArrow: false,
                              subTitle: Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text("${NumberFormat('#,###').format(service.price)}đ/${service.unit}"),
                              ),
                              trailing: _loadRoomServiceState(service),
                            );
                          },
                        ).toList()),
                      ],
                    );
                  } else {
                    return SafeArea(
                      child: Text(AppLocalizations.of(context)!.admin_manage_rooms_detail_students_empty),
                    );
                  }

                default:
                  return const SafeArea(
                    child: Center(
                      child: CupertinoActivityIndicator(
                        radius: 10,
                      ),
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  _loadRoomServiceState(Service service) {
    // the room has at least 1 service can be goes here
    // getting each service in the room and compare to the passed service to dertermine CupertinoSwitch state
    return CupertinoSwitch(
      value: (service.rooms ?? []).map((e) => (e as DocumentReference)).any((element) => element.id == room.id),
      onChanged: null,
    );
  }
}
