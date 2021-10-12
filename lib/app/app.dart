import 'package:bvu_dormitory/app/constants/app.themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.provider.dart';
import '../repositories/auth.repository.dart';
import '../screens/home/home.screen.dart';
import '../screens/login/login.screen.dart';
import 'constants/app.routes.dart';

// This widget is the root of your application.
class BVUDormitoryApp extends StatelessWidget {
  const BVUDormitoryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(
          create: (context) => AppProvider(),
        ),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) => FutureBuilder<bool>(
          future: AuthRepository.isAuthenticated(),
          builder: (context, snapshot) {
            log('app auth:');
            print(snapshot.data);

            return MaterialApp(
              routes: AppRoutes.collect(),
              home: (snapshot.hasData && snapshot.data == true)
                  ? HomeScreen()
                  : LoginScreen(),
              onGenerateRoute: (settings) {
                log('checking user...');
                print(FirebaseAuth.instance.currentUser);
              },
              onGenerateTitle: (context) {
                return AppLocalizations.of(context)?.appName ?? "app_name";
              },
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              themeMode: appProvider.appThemeMode,
              theme: AppThemes.light,
              darkTheme: AppThemes.dark,
            );
          },
        ),
      ),
    );
  }
}
