import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/helpers/extensions/datetime.extensions.dart';
import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:bvu_dormitory/models/inform.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/newsfeed.repository.dart';
import 'newsfeed.controller.dart';

class NewsFeedScreen extends BaseScreen<NewsFeedController> {
  NewsFeedScreen({Key? key, required this.user}) : super(key: key, haveNavigationBar: false);

  final AppUser user;

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  NewsFeedController provideController(BuildContext context) {
    return NewsFeedController(
      context: context,
      title: AppLocalizations.of(context)?.home_screen_navbar_item_newsfeed ?? "home_screen_navbar_item_newsfeed",
    );
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _navBar(context),
        _body(context),
      ],
    );
  }

  _navBar(BuildContext context) {
    final controller = context.read<NewsFeedController>();

    return AppBar(
      elevation: 1,
      centerTitle: false,
      leading: null,
      automaticallyImplyLeading: false,
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
              if (user.role == UserRole.admin) ...{
                _composeButton(context),
              },
              // const SizedBox(width: 15),
              // _addGroupButton(context),
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

  _composeButton(BuildContext context) {
    final controller = context.read<NewsFeedController>();

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
              AppLocalizations.of(context)?.newsfeed_compose_button ?? "newsfeed_compose_button",
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
      onPressed: () {
        controller.showInformModal();
      },
    );
  }

  _body(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: _newsList(),
      ),
    );
  }

  _newsList() {
    final controller = context.read<NewsFeedController>();

    return StreamBuilder<List<Inform>>(
      stream: NewsFeedRepository.syncAll(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log(snapshot.error.toString());
          controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
        }

        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final inform = snapshot.data![index];
              return _newsItem(inform);
            },
          );
        }

        return const CupertinoActivityIndicator(radius: 10);
      },
    );
  }

  _newsItem(Inform inform) {
    final controller = context.read<NewsFeedController>();

    final contentController = QuillController(
      document: Document.fromJson(jsonDecode(inform.content)),
      selection: const TextSelection.collapsed(offset: 0),
    );

    final borderStyle = BorderSide(
      width: 1,
      color: AppColor.borderColor(context.read<AppController>().appThemeMode),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColor.secondaryBackgroundColor(context.read<AppController>().appThemeMode),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 24,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              // color: Colors.grey.shade200,
              border: Border(bottom: BorderSide(width: 0.25, color: Colors.grey.shade600)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        inform.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        DateTime.fromMillisecondsSinceEpoch(inform.timestamp.millisecondsSinceEpoch)
                            .getReadableDateString(),
                        style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                // menu
                if (user.role == UserRole.admin) ...{
                  CupertinoButton(
                    minSize: 10,
                    padding: EdgeInsets.zero,
                    child: const Icon(FluentIcons.more_horizontal_24_regular),
                    onPressed: () {
                      controller.onInformMenuButtonPressed(inform);
                    },
                  ),
                },
              ],
            ),
          ),

          // content
          Container(
            padding: const EdgeInsets.all(15),
            child: QuillEditor.basic(controller: contentController, readOnly: true),
          ),
        ],
      ),
    );
  }
}
