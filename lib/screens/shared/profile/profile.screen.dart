import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/repositories/auth.repository.dart';
import 'package:bvu_dormitory/screens/shared/login/login.screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/base/base.screen.dart';
import 'profile.controller.dart';

class ProfileScreen extends BaseScreen<ProfileController> {
  ProfileScreen({Key? key}) : super(key: key, haveNavigationBar: false);

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  provideController(BuildContext context) {
    return ProfileController(context: context, title: AppLocalizations.of(context)!.home_screen_navbar_item_profile);
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _navBar(context),
        _body(context),
      ],
    );
  }

  _navBar(BuildContext context) {
    final controller = context.read<ProfileController>();

    return AppBar(
      elevation: 1,
      centerTitle: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            controller.title,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          Row(
            children: [
              _signoutButton(context),
            ],
          ),
        ],
      ),
      flexibleSpace: Container(
        height: 110,
        decoration: BoxDecoration(
          gradient: AppColor.mainAppBarGradientColor,
        ),
      ),
    );
  }

  _body(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Text('data'),
    );
  }

  _signoutButton(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.only(top: 7, bottom: 7, left: 15, right: 10),
        // margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.admin_manage_sign_out,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(FluentIcons.power_24_regular, color: Colors.white, size: 20)
          ],
        ),
      ),
      onPressed: () {
        AuthRepository.signOut().then((value) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        });
      },
    );
  }
}
