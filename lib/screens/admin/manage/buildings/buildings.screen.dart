import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/screens/admin/manage/buildings/buildings.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/buildings/widgets/buildings.body.dart';

import './search/buildings.search.screen.dart';

class AdminBuildingsScreen extends BaseScreen<AdminBuildingsController> {
  AdminBuildingsScreen({
    Key? key,
    String? previousPageTitle,
    this.pickingRoom = false,
  }) : super(key: key, previousPageTitle: previousPageTitle);

  final bool pickingRoom;

  @override
  AdminBuildingsController provideController(BuildContext context) {
    return AdminBuildingsController(
      context: context,
      pickingRoom: pickingRoom,
      title: AppLocalizations.of(context)?.admin_manage_buildings_title ?? "admin_manage_buildings_title",
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {
    // return CupertinoButton(
    //   padding: EdgeInsets.zero,
    //   minSize: 20,
    //   borderRadius: BorderRadius.circular(20),
    //   child: const Icon(FluentIcons.search_24_regular),
    //   onPressed: () {
    //     Navigator.of(context).push(
    //       CupertinoPageRoute(
    //         builder: (_) => AdminBuildingsSearchScreen(
    //           previousPageTitle: Provider.of<AdminBuildingsController>(context).title,
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: const [
          Scrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: AdminBuildingsBody(),
            ),
          ),
          // Positioned(
          //   right: 10,
          //   bottom: 0,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       context.read<AdminBuildingsController>().showBuildingEditBottomSheet();
          //     },
          //     style: ElevatedButton.styleFrom(
          //       shape: const CircleBorder(),
          //       padding: const EdgeInsets.all(10),
          //     ),
          //     child: const Icon(FluentIcons.tab_add_24_regular),
          //   ),
          //   // CupertinoButton(
          //   //   padding: const EdgeInsets.all(0),
          //   //   borderRadius: BorderRadius.circular(50),
          //   //   child: Container(
          //   //     child: const Icon(FluentIcons.folder_add_24_regular, color: Colors.blue),
          //   //     padding: const EdgeInsets.all(15),
          //   //     decoration: BoxDecoration(
          //   //       color: Colors.white,
          //   //       shape: BoxShape.circle,
          //   //       border: Border.all(color: Colors.grey.withOpacity(0.15)),
          //   //       boxShadow: [
          //   //       ],
          //   //     ),
          //   //   ),
          //   //   onPressed: () {
          //   //     context.read<AdminBuildingsController>().showBuildingEditBottomSheet();
          //   //   },
          //   // ),
          // ),
        ],
      ),
    );
  }
}
