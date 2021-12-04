import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/base/base.controller.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/auth.repository.dart';
import 'package:bvu_dormitory/repositories/user.repository.dart';
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
  ProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key, haveNavigationBar: false);

  final AppUser user;

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  provideController(BuildContext context) {
    return ProfileController(
      context: context,
      title: AppLocalizations.of(context)!.home_screen_navbar_item_profile,
      user: user,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _navBar(context),
            _body(context),
          ],
        ),
      ),
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
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 10),
            Icon(FluentIcons.power_24_regular, color: Colors.white.withOpacity(0.85), size: 20)
          ],
        ),
      ),
      onPressed: () {
        final controller = context.read<ProfileController>();

        controller.showConfirmDialog(
          title: AppLocalizations.of(context)!.profile_confirm_signout,
          confirmType: DialogConfirmType.submit,
          dismissible: true,
          onSubmit: () {
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
      },
    );
  }

  _body(BuildContext context) {
    return Scrollbar(
      thickness: 1,
      child: SingleChildScrollView(
          // padding: const EdgeInsets.all(20),
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _profileHeader(user),
          const SizedBox(height: 30),
          Flexible(
            child: _profileMenu(user),
          ),
        ],
      )),
    );
  }

  _profileHeader(AppUser user) {
    _avatar() {
      return Stack(
        fit: StackFit.passthrough,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 75,
            backgroundImage: user.photoURL == null
                ? const AssetImage('lib/assets/icons/user.png')
                : Image.network(user.photoURL!).image,
          ),

          // change avatar button
          Positioned(
            bottom: -5,
            right: -20,
            child: CupertinoButton(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: AppColor.borderColor(context.read<AppController>().appThemeMode)),
                ),
                child: const Icon(FluentIcons.camera_28_filled),
              ),
              onPressed: () {},
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _avatar(),
          const SizedBox(height: 15),
          SelectableText(
            user.fullName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 25),
          Container(
            decoration: BoxDecoration(
              color: AppColor.secondaryBackgroundColor(context.read<AppController>().appThemeMode),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 1,
                color: AppColor.borderColor(context.read<AppController>().appThemeMode),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: SelectableText(
                      user.role.name.replaceFirst(user.role.name[0], user.role.name[0].toUpperCase()),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 20,
                  width: 1,
                  color: Colors.grey.withOpacity(0.5),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: SelectableText(
                      user.phoneNumber.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _profileMenu(AppUser appUser) {
    final controller = context.read<ProfileController>();

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: List.generate(
          controller.menuGroups.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: controller.menuGroups[index],
          ),
        ),
      ),
    );
  }
}
