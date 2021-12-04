import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:connectivity/connectivity.dart';
import 'package:provider/src/provider.dart';

// import 'package:bvu_dormitory/helpers/extensions/navigator.extensions.dart';

enum DialogConfirmType { update, submit }

class AppModalBottomSheetItem {
  Widget icon;
  String label;
  TextStyle? labelStyle;
  void Function()? onPressed;

  AppModalBottomSheetItem({
    required this.label,
    required this.icon,
    this.onPressed,
    this.labelStyle,
  });
}

class AppModalBottomSheetMenuGroup {
  String? title;
  TextStyle? titleStyle;
  List<AppModalBottomSheetItem> items;

  AppModalBottomSheetMenuGroup({
    required this.items,
    this.title,
    this.titleStyle,
  });
}

abstract class BaseController extends ChangeNotifier {
  AppLocalizations? get appLocalizations => AppLocalizations.of(context);
  NavigatorState get navigator => Navigator.of(context);

  final BuildContext context;
  final String title;

  BaseController({required this.title, required this.context});

  Future<bool> hasConnectivity() async {
    final result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      showSnackbar(appLocalizations!.app_connectivity_none, const Duration(seconds: 3), () {});
    }

    return result != ConnectivityResult.none;
  }

  /// showing a loading dialog when logic is in proccess
  showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        contentPadding: EdgeInsets.all(15),
        content: LinearProgressIndicator(minHeight: 2),
      ),
    );
  }

  // showing an error alert dialog
  showErrorDialog(String content) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(appLocalizations?.app_dialog_title_error ?? "app_dialog_title_error"),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
                child: Text(appLocalizations?.app_dialog_action_ok ?? "Ok"), onPressed: () => Navigator.pop(context)),
          ],
        );
      },
    );
  }

  showConfirmDialog({
    Widget? body,
    bool dismissible = false,
    required String title,
    required DialogConfirmType confirmType,
    required void Function() onSubmit,
    void Function()? onDismiss,
  }) {
    String getConfirmationTitle(DialogConfirmType type) {
      switch (type) {
        case DialogConfirmType.submit:
          return appLocalizations?.app_dialog_action_submit ?? "app_dialog_action_submit";

        case DialogConfirmType.update:
          return appLocalizations?.app_dialog_action_update ?? "app_dialog_action_update";

        default:
          return "localle_name_undefined";
      }
    }

    showDialog(
      context: context,
      barrierDismissible: dismissible,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: body,
        actions: [
          CupertinoDialogAction(
            child: Text(
              appLocalizations?.app_dialog_action_cancel ?? "app_dialog_action_cancel",
              style: const TextStyle(color: Colors.red),
            ),
            onPressed: () {
              if (onDismiss != null) {
                onDismiss();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          CupertinoDialogAction(
            child: Text(getConfirmationTitle(confirmType)),
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }

  void showSnackbar(String content, Duration duration, void Function()? onDone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: duration,
      ),
    );

    Future.delayed(duration, () {
      if (onDone != null) onDone();
    });
  }

  void showBottomSheetMenuModal(
      String title, TextStyle? titleStyle, bool dismissible, List<AppModalBottomSheetMenuGroup> groups) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Scrollbar(
          child: SingleChildScrollView(
            child: Material(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// bottom sheet header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    color: AppColor.secondaryBackgroundColor(context.read<AppController>().appThemeMode),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: titleStyle ??
                              const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Icon(AntDesign.close, size: 20),
                            onPressed: () {
                              navigator.pop();
                            }),
                      ],
                    ),
                  ),

                  /// bottom sheet body | holding menu groups
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: true,
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final theGroup = groups[index];

                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 0.5,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // menu group title
                            if (theGroup.title != null) ...{
                              Container(
                                padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
                                child: Text(
                                  theGroup.title ?? "",
                                  style: titleStyle ??
                                      TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.textColor(context.read<AppController>().appThemeMode),
                                      ),
                                ),
                              ),
                            },
                            ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: theGroup.items.length,
                              itemBuilder: (context, index) {
                                final theItem = theGroup.items[index];
                                return CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: ListTile(
                                    title: Text(
                                      theItem.label,
                                      style: theItem.labelStyle ??
                                          TextStyle(
                                            color: AppColor.textColor(context.read<AppController>().appThemeMode),
                                          ),
                                    ),
                                    minLeadingWidth: 15,
                                    leading: theItem.icon,
                                  ),
                                  onPressed: theItem.onPressed,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
