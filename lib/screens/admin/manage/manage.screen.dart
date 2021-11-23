import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

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
import 'package:provider/src/provider.dart';

class AdminManageScreen extends BaseScreen<AdminManageController> {
  AdminManageScreen({
    Key? key,
    required this.user,
  }) : super(key: key, haveNavigationBar: false);

  @override
  AdminManageController provideController(BuildContext context) {
    return AdminManageController(
      context: context,
      title: AppLocalizations.of(context)?.admin_manage_title ?? "admin_manage_title",
    );
  }

  final AppUser user;

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        // _sliverAppBar(context),
        _header(),
        const Expanded(child: AdminManageMenu()),
        // AdminManageCharts(),
        // Expanded(
        //   child: AdminManageCharts(),
        // )
      ],
    );
  }

  _header() {
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
            radius: 20,
            backgroundImage: AssetImage('lib/assets/icons/user.png'),
          ),
        ],
      );
    }

    _nameSection() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.admin_manage_welcome,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Flexible(
                      child: SelectableText(
                        user.fullName,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
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
        ],
      );
    }

    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        width: double.infinity,
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, left: 20, right: 20, bottom: 75),
        decoration: BoxDecoration(
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
          mainAxisSize: MainAxisSize.min,
          children: [
            _appNameSection(),
            const SizedBox(height: 30),
            _nameSection(),
          ],
        ),
      ),
    );
  }
}
