import 'package:bvu_dormitory/app/app.logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AppNotifications {
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

  static listen() {
    FirebaseMessaging.onMessage.listen((event) {
      logger.w('on FCM message');
      logger.v(event);
    });
  }
}
