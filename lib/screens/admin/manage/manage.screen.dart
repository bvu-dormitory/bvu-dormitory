import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/screens/admin/manage/manage.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/widgets/manage.menu.dart';
import 'package:bvu_dormitory/repositories/user.repository.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/repositories/auth.repository.dart';
import 'package:bvu_dormitory/screens/shared/login/login.screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Column(
      children: [
        _sliverAppBar(context),
        const Expanded(child: AdminManageMenu()),
        // AdminManageCharts(),
        // Expanded(
        //   child: AdminManageCharts(),
        // )
      ],
    );
  }

  _sliverAppBar(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: UserRepository.getCurrentFireStoreUserStream(),
      builder: (context, snapshot) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.admin_manage_welcome,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      snapshot.data?.fullName ?? "error_getting_name",
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 15,
                backgroundImage: AssetImage('lib/assets/icons/default-user.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
