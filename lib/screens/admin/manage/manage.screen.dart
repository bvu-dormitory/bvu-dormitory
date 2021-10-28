import 'dart:developer';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/repositories/auth.repository.dart';
import 'package:bvu_dormitory/screens/shared/login/login.screen.dart';
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
      title: AppLocalizations.of(context)?.admin_manage_title ?? "admin_manage_title",
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        _sliverAppBar(context),
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

  _sliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 1,
      expandedHeight: 120,
      centerTitle: false,
      titleSpacing: 30,
      title: StreamBuilder<AppUser?>(
        stream: UserRepository.getCurrentFireStoreUserStream(),
        builder: (context, snapshot) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.admin_manage_welcome(snapshot.data?.fullName ?? "error_getting_name"),
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                // const CircleAvatar(
                //   backgroundColor: Colors.amber,
                //   radius: 15,
                //   backgroundImage: AssetImage('lib/assets/icons/default-user.png'),
                // ),
                CupertinoButton(
                  color: Colors.white.withOpacity(0.85),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Sign out',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    AuthRepository.signOut().then(
                      (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      // stretch: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          // final top = constraints.biggest.height;
          // log("$top");

          return FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Stack(
              children: [
                Container(
                  width: double.infinity,
                  child: const Image(
                    image: AssetImage('lib/assets/2805830.jpg'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topLeft,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colors.blue.withOpacity(0.75),
                        Colors.lightBlue.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
