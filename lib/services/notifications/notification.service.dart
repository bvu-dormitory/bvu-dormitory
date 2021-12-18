import 'dart:developer';

import 'package:bvu_dormitory/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:bvu_dormitory/app/app.logger.dart';
import 'package:bvu_dormitory/repositories/auth.repository.dart';

class NotificationService {
  static FirebaseMessaging get instance => FirebaseMessaging.instance;

  static getDeviceToken() async {
    instance.getToken().then(
      (token) {
        logger.i('FCM device token: $token');
      },
    ).catchError(
      (onError) {
        logger.e(onError);
      },
    );
  }

  /// subscribing to the NewsFeed notifications
  static registerToNewsFeedTopic() {
    FirebaseMessaging.instance.subscribeToTopic('newsfeed');
  }

  /// start listening to FCM notifications (forground/background-terminated/on pressed open app)
  static listen() {
    // allow receiving FCM messages if the app is in forground (visible to user)
    FirebaseMessaging.onMessage.listen((event) {
      logger.i('FCM forground message..,');
      logger.i(event.data.toString());

      if (event.data['logged_out'] == "true") {
        if (AuthRepository.instance.currentUser != null) {
          AuthRepository.signOut().then((value) {
            log('remote logged out');
          });
        }
      }
    });

    // called when the app is in the background or terminated
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // triggerd when user presses on FCM notification to open the App
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      logger.w('FCM opened app message coming');
      logger.i(event);
    });
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    logger.i("on background/terminated message: ");
    logger.i(message.data.toString());

    if (message.data['logged_out'] == "true") {
      await Firebase.initializeApp();

      // perform remote signing out if current user is logged in
      if (AuthRepository.instance.currentUser != null) {
        AuthRepository.signOut().then((value) {
          log('remote logged out');
          // Application.restartApp();
        });
      } // end if
    }
  }
}
