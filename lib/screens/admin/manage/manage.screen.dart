import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/screens/admin/manage/manage.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/widgets/manage.menu.dart';
import 'package:bvu_dormitory/repositories/user.repository.dart';

class AdminManageScreen extends BaseScreen<AdminManageController> {
  AdminManageScreen({Key? key}) : super(key: key, haveNavigationBar: false);

  @override
  AdminManageController provideController(BuildContext context) {
    return AdminManageController(
      context: context,
      title: AppLocalizations.of(context)?.admin_manage_title ??
          "admin_manage_title",
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          pinned: true,
          elevation: 3,
          expandedHeight: 150,
          centerTitle: false,
          titleSpacing: 30,
          title: StreamBuilder<AppUser?>(
            stream: UserRepository.getCurrentFireStoreUserStream(),
            builder: (context, snapshot) => Text(
              "Xin chào, ${snapshot.data?.name}",
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // stretch: true,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/2805830.jpg'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topLeft,
                ),
              ),
            ),
          ),
        ),
      ],
      body: Container(
        // padding: EdgeInsets.all(10),
        color: AppColor.backgroundColor,
        child: Column(
          children: const [
            Expanded(child: AdminManageMenu()),
            // AdminManageMenu(),
            // AdminManageCharts(),
            // Expanded(
            //   child: AdminManageCharts(),
            // )
          ],
        ),
      ),
    );
  }
}
