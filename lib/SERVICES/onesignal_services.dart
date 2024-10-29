import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'api_config.dart';

class OneSignalService {
  static Future<void> initialize() async {
    try {
      OneSignal.initialize(APIConfig.oneSignalAppId);
      OneSignal.Debug.setLogLevel(OSLogLevel.debug);
      await OneSignal.Notifications.requestPermission(true);

      if (kDebugMode) print("OneSignal initialized successfully");
    } catch (e) {
      if (kDebugMode) print("Error initializing OneSignal: $e");
      rethrow;
    }
  }
}
