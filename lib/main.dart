import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bvu_dormitory/app/app.dart';
import 'package:bvu_dormitory/app/app.repository.dart';

/// Don't implement codes here - prefer seperating into functions then invoke them.
/// Keep this file as simple as possible.
void main() async {
  await prepare();
  runApp(const Application());
}

/// Prepair things before running the App.
prepare() async {
  WidgetsFlutterBinding.ensureInitialized();

  await prepareData();
  await prepareApprerance();
}

prepareApprerance() async {
  // transparent Status Bar on Android for all screens
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  SystemChrome.setPreferredOrientations([
    // allow only potrait up (normal) orientation for the entire app.
    DeviceOrientation.portraitUp,
  ]);
}

prepareData() async {
  initFirebase() async {
    await Firebase.initializeApp();

    // AppNotifications.getDeviceToken();

    log('Firebase init done');
  }

  initSharedPreferences() async {
    await AppRepository.initSharedPreferences();
    log('SharedPreferences init done');
  }

  await initFirebase();
  await initSharedPreferences();
}
