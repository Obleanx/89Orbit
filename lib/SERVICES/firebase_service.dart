import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Define channel ID, name, and description
  static const String channelId = 'high_importance_channel';
  static const String channelName = 'High Importance Notifications';
  static const String channelDescription =
      'This channel is used for important notifications.';

  static Future<void> initialize() async {
    try {
      // Initialize Firebase
      await Firebase.initializeApp();
      if (kDebugMode) print("Firebase initialized successfully");

      // Request notification permissions first
      await _requestNotificationPermissions();

      // Initialize other components
      await _initializeMessaging();
      await _initializeLocalNotifications();

      // Set up foreground notification presentation options
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Debug token and settings
      await _debugNotificationSetup();
    } catch (e) {
      if (kDebugMode) print("Error initializing Firebase: $e");
      rethrow;
    }
  }

  static Future<void> _requestNotificationPermissions() async {
    try {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: true,
        carPlay: false,
        criticalAlert: false,
      );

      if (kDebugMode) {
        print('User granted permission: ${settings.authorizationStatus}');
      }

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        if (kDebugMode) {
          print('WARNING: Notifications permission denied by user');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting notification permissions: $e');
      }
    }
  }

  static Future<void> _initializeMessaging() async {
    try {
      // Get FCM token
      String? token = await FirebaseMessaging.instance.getToken();
      if (kDebugMode) print("FCM Token: $token");

      // Set up token refresh listener
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        if (kDebugMode) print("New FCM Token: $newToken");
        // Here you could send the new token to your server
      });

      // Set up message handlers
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // Subscribe to topics if needed
      await FirebaseMessaging.instance.subscribeToTopic('all');
    } catch (e) {
      if (kDebugMode) print("Error initializing Firebase Messaging: $e");
    }
  }

  static Future<void> _initializeLocalNotifications() async {
    try {
      // Initialize local notifications
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _localNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _handleNotificationTap,
      );

      // Create the notification channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
        showBadge: true,
      );

      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing local notifications: $e');
      }
    }
  }

  static void _handleNotificationTap(NotificationResponse details) {
    if (kDebugMode) {
      print('Notification tapped: ${details.payload}');
    }
    // Handle notification tap here
  }

  static Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    if (kDebugMode) {
      print('Notification opened app: ${message.data}');
    }
    // Handle notification tap when app was in background
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print("Got a message whilst in the foreground!");
      print("Message data: ${message.data}");
      print("Message notification: ${message.notification?.title}");
    }

    if (message.notification != null) {
      await _showNotification(
        title: message.notification!.title,
        body: message.notification!.body,
        payload: message.data.toString(),
      );
    }
  }

  static Future<void> _showNotification({
    String? title,
    String? body,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _localNotificationsPlugin.show(
        DateTime.now().millisecond, // Unique ID for each notification
        title ?? 'Notification',
        body ?? 'New message',
        platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error showing notification: $e');
      }
    }
  }

  static Future<void> _debugNotificationSetup() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final settings = await FirebaseMessaging.instance.getNotificationSettings();

    if (kDebugMode) {
      print('================== Notification Debug Info ==================');
      print('FCM Token: $fcmToken');
      print('Authorization Status: ${settings.authorizationStatus}');
      print('Alert Setting: ${settings.alert}');
      print('Sound Setting: ${settings.sound}');
      print('Badge Setting: ${settings.badge}');
      // print('Provisional Setting: ${settings.provisional}');
      print('=========================================================');
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print("Message data: ${message.data}");
  }

  if (message.notification != null) {
    await FirebaseService._showNotification(
      title: message.notification!.title,
      body: message.notification!.body,
      payload: message.data.toString(),
    );
  }
}
