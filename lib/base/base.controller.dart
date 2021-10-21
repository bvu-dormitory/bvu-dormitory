import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum DialogConfirmType { update, submit }

abstract class BaseController extends ChangeNotifier {
  AppLocalizations? get appLocalizations => AppLocalizations.of(context);
  final BuildContext context;
  final String title;

  BaseController({required this.title, required this.context});

  // showing an error alert dialog
  showErrorDialog(String content) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(appLocalizations?.app_dialog_title_error ??
              "app_dialog_title_error"),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
                child: Text(appLocalizations?.app_dialog_action_ok ?? "Ok"),
                onPressed: () => Navigator.pop(context)),
          ],
        );
      },
    );
  }

  showConfirmDialog({
    required String title,
    required Widget? body,
    required DialogConfirmType confirmType,
    required void Function() onSubmit,
  }) {
    String getConfirmationTitle(DialogConfirmType type) {
      switch (type) {
        case DialogConfirmType.submit:
          return appLocalizations?.app_dialog_action_submit ??
              "app_dialog_action_submit";

        case DialogConfirmType.update:
          return appLocalizations?.app_dialog_action_update ??
              "app_dialog_action_update";

        default:
          return "localle_name_undefined";
      }
    }

    showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: body,
        actions: [
          CupertinoDialogAction(
            child: Text(
              appLocalizations?.app_dialog_action_cancel ??
                  "app_dialog_action_cancel",
              style: const TextStyle(color: Colors.red),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: Text(getConfirmationTitle(confirmType)),
            onPressed: onSubmit,
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
