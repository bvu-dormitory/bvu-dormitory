import 'dart:developer';

import 'package:bvu_dormitory/services/notifications/notification.service.dart';
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

    NotificationService.listen();
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
              if (snapshot.hasData) {
                log('User logged in');
                log(snapshot.data.toString());

                // Fires when a new FCM token is generated.
                // updating FCM token only if the user logged in
                // FirebaseMessaging.instance.onTokenRefresh.listen(AuthRepository.updateUserFCMToken());
              }

              return MaterialApp(
                // ROUTING
                routes: AppRoutes.go, // ignore if using onGenerateRoute
                home: (snapshot.hasData) ? const HomeScreen() : const LoginScreen(),
                onUnknownRoute: (settings) {
                  logger.w('route not found, redirect to the 404 screen');
                  return MaterialPageRoute(
                    builder: (context) => AppRoutes.notFound.screen,
                  );
                },
                debugShowCheckedModeBanner: false,
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
