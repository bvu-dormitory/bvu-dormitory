import 'package:bvu_dormitory/app/app.logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

  //
  static listen() {
    // allow receiving FCM messages if the app is in forground (visible to user)
    FirebaseMessaging.onMessage.listen((event) {
      logger.w('FCM foreground message coming');
      logger.i(event);
    });

    // called when the app is in the background or terminated
    FirebaseMessaging.onBackgroundMessage((message) {
      logger.i(message.data);
      return Future.value();
    });

    // triggerd when user presses on FCM notification to open the App
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      logger.w('FCM background message coming');
      logger.i(event);
    });
  }
}
