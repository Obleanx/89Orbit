// firebase_service.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    await _setupFirebaseMessaging();
  }

  static Future<void> _setupFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }

    String? token = await messaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $token');
    }

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (kDebugMode) {
      print("Handling a background message: ${message.messageId}");
    }
  }
}

class FirebaseApi {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBH4OdG3YKIP1JipJTW6VXqcKgZLe5aB_Y",
          appId: "1:328467516650:android:ef76a807ec69df1dc6db93",
          messagingSenderId: "328467516650",
          projectId: "fianderapp",
        ),
      );
      if (kDebugMode) {
        print("Firebase initialized successfully");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error initializing Firebase: $e");
      }
      throw e; // Re-throw the error so it can be caught in the main function
    }
  }

  static Future<void> initNotification() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    try {
      await _firebaseMessaging.requestPermission();
      final fCMToken = await _firebaseMessaging.getToken();
      if (kDebugMode) {
        print("FCM Token: $fCMToken");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in initNotification: $e");
      }
      throw e; // Re-throw the error so it can be caught in the main function
    }
  }
}

class LoadingApp extends StatelessWidget {
  const LoadingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text("An error occurred: $error",
                style: TextStyle(color: Colors.red)),
          ),
        ),
      ),
    );
  }
}
