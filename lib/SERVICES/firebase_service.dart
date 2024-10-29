import 'package:fiander/SERVICES/api_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: APIConfig.firebaseConfig,
      );
      if (kDebugMode) print("Firebase initialized successfully");

      await _initializeMessaging();
    } catch (e) {
      if (kDebugMode) print("Error initializing Firebase: $e");
      rethrow;
    }
  }

  static Future<void> _initializeMessaging() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (kDebugMode) print("FCM Token: $token");

      // Set up message handlers
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } catch (e) {
      if (kDebugMode) print("Error initializing Firebase Messaging: $e");
    }
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print("Got a message whilst in the foreground!");
      print("Message data: ${message.data}");
      if (message.notification != null) {
        print("Message notification: ${message.notification}");
      }
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}
