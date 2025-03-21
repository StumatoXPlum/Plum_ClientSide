import 'package:firebase_messaging/firebase_messaging.dart';

class Notifications {
  final _firebaseNessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseNessaging.requestPermission();
    final fcmToken = await _firebaseNessaging.getToken();
    print('Token: $fcmToken');
  }
}
