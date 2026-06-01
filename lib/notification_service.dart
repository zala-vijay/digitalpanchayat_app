import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static Future<void> init() async {
    // Request permission
    await FirebaseMessaging.instance.requestPermission();

    // Foreground listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔔 Notification Received:");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
    });
  }
}