import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FCMTokenManager {
  static String? _token;

  static String? get token => _token;

  static Future<void> initialize() async {
    // Get the token if it's already available
    _token = await FirebaseMessaging.instance.getToken();
    if (kDebugMode) {
      print("FCM Token: $_token");
    }

    // Any time the token refreshes, store this in your backend if necessary
    FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
      _token = token;
      if (kDebugMode) {
        print("FCM Token refreshed: $token");
      }
      // Here you would send the token to your server
      _sendTokenToServer(token);
    });
  }

  static Future<String?> getToken() async {
    if (_token == null) {
      _token = await FirebaseMessaging.instance.getToken();
    }
    return _token;
  }

  static void _sendTokenToServer(String token) {
    // TODO: Implement the logic to send the token to your server
    // This could be an API call to your backend
  }

  static Future<void> deleteToken() async {
    await FirebaseMessaging.instance.deleteToken();
    _token = null;
  }
}

class LoadingApp extends StatelessWidget {
  const LoadingApp({super.key});

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
