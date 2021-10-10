import 'dart:developer';

import 'package:bvu_dormitory/repositories/auth.repository.dart';
import 'package:bvu_dormitory/screens/login/login.screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'constants/app.routes.dart';
import 'providers/app.provider.dart';
import 'screens/home/home.screen.dart';

/// Don't implement codes here - prefer seperating into functions then invoking
void main() async {
  await prepare();

  runApp(const BVUDormitoryApp());
}

/// Prepair things before running the App.
prepare() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initFirebase();

  // // transparent Status Bar on Android
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //   ),
  // );

  SystemChrome.setPreferredOrientations([
    // allow only potrait up (normal) orientation for the entire app.
    DeviceOrientation.portraitUp,
  ]);
}

initFirebase() async {
  await Firebase.initializeApp();
  log('firebase init done...');
}

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
      child: FutureBuilder<bool>(
        future: AuthRepository.isAuthenticated(),
        builder: (context, snapshot) {
          print('app auth:');
          print(snapshot.data);

          return MaterialApp(
            routes: AppRoutes.collect(),
            home: (snapshot.data ?? false) ? HomeScreen() : LoginScreen(),
            // onGenerateRoute: (settings) {
            //   log('checking user...');
            //   FirebaseAuth.instance.authStateChanges().listen((event) {
            //     print(event);
            //   }, onError: (error) {
            //     print(error);
            //   });
            // },
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)?.appName ?? "app_name",
            // theme: AppThemes.light,
            // darkTheme: AppThemes.dark,
            // themeMode: provider.appThemeMode,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
