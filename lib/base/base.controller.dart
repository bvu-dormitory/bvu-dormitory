import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class BaseController extends ChangeNotifier {
  AppLocalizations? get appLocalizations => AppLocalizations.of(context);

  BuildContext context;

  BaseController({required this.context});

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
}
