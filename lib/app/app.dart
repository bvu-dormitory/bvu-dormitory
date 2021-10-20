import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/app/constants/app.themes.dart';
import 'package:bvu_dormitory/screens/shared/home/home.screen.dart';
import 'package:bvu_dormitory/screens/shared/login/login.screen.dart';
import 'package:bvu_dormitory/repositories/auth.repository.dart';

import 'app.logger.dart';
import 'app.controller.dart';
import 'constants/app.routes.dart';

// This widget is the root of your application.
class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  void initState() {
    super.initState();

    // allow receiving FCM messages if the app is in forground (visible to user)
    FirebaseMessaging.onMessage.listen((event) {
      logger.w('FCM foreground message coming');
      logger.i(event);
    });

    // allow receiving FCM messages if the app is still alive (not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      logger.w('FCM background message coming');
      logger.i(event);
    });
  }

  @override
  Widget build(BuildContext _) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppController>(
          create: (_) => AppController(context: _),
          lazy: false,
        ),
      ],
      child: Consumer<AppController>(
        builder: (context, appProvider, child) {
          return FutureBuilder(
            // stream: AuthRepository.instance.userChanges(),
            future: AuthRepository.instance.userChanges().first,
            builder: (context, snapshot) {
              return MaterialApp(
                // ROUTING
                routes: AppRoutes.go, // ignore if using onGenerateRoute
                home: (snapshot.hasData)
                    ? const HomeScreen()
                    : const LoginScreen(),
                // onGenerateRoute: (settings) {
                //   log('onGenerateRoute...');
                //   return AuthRepository.instance.currentUser != null
                //       ? MaterialPageRoute(
                //           builder: (context) => AppRoutes.login.screen,
                //         )
                //       : MaterialPageRoute(
                //           builder: (context) =>
                //               AppRoutes.getByName(settings.name ?? "").screen,
                //         );
                // },
                onUnknownRoute: (settings) {
                  logger.w('route not found, redirect to the 404 screen');
                  return MaterialPageRoute(
                    builder: (context) => AppRoutes.notFound.screen,
                  );
                },
                onGenerateTitle: (context) {
                  return AppLocalizations.of(context)?.app_name ?? "app_name";
                },
                // LOCALIZING
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                // THEMING
                themeMode: appProvider.appThemeMode,
                theme: AppThemes.light,
                darkTheme: AppThemes.dark,
              );
            },
          );
        },
      ),
    );
  }
}
