import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'message.controller.dart';

class MessagesScreen extends BaseScreen<MessageController> {
  MessagesScreen({Key? key}) : super(key: key, haveNavigationBar: false);

  @override
  MessageController provideController(BuildContext context) {
    return MessageController(
      context: context,
      title: AppLocalizations.of(context)?.home_screen_navbar_item_chat ?? "home_screen_navbar_item_chat",
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

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
    final controller = context.read<MessageController>();

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
              _composeButton(context),
              const SizedBox(width: 15),
              _addGroupButton(context),
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

  _addGroupButton(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.only(top: 7, bottom: 7, left: 7.5, right: 7.5),
        // margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(
          FluentIcons.people_add_24_regular,
          color: Colors.white,
          size: 20,
        ),
      ),
      onPressed: () {},
    );
  }

  _composeButton(BuildContext context) {
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
              AppLocalizations.of(context)?.message_compose_button ?? "message_compose_button",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(FluentIcons.compose_24_regular, color: Colors.white, size: 20)
          ],
        ),
      ),
      onPressed: () {},
    );
  }

  _body(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Text('data'),
    );
  }
}
