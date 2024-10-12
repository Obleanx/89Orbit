import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (const bool.fromEnvironment('dart.vm.product')) {
      // Release mode (use default production configuration)
      return const FirebaseOptions(
        apiKey: 'AIzaSyBH4OdG3YKIP1JipJTW6VXqcKgZLe5aB_Y',
        appId: '1:328467516650:android:ef76a807ec69df1dc6db93',
        messagingSenderId: '328467516650',
        projectId: 'fianderapp',
        storageBucket: 'fianderapp.appspot.com',
      );
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      // Android configuration
      return const FirebaseOptions(
        apiKey: 'AIzaSyBH4OdG3YKIP1JipJTW6VXqcKgZLe5aB_Y',
        appId: '1:328467516650:android:ef76a807ec69df1dc6db93',
        messagingSenderId: '328467516650',
        projectId: 'fianderapp',
        storageBucket: 'fianderapp.appspot.com',
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS (Add real values for iOS keys if you're targeting iOS)
      return const FirebaseOptions(
        apiKey: 'YOUR_IOS_API_KEY',
        appId: 'YOUR_IOS_APP_ID',
        messagingSenderId: 'YOUR_IOS_MESSAGING_SENDER_ID',
        projectId: 'fianderapp',
        storageBucket: 'fianderapp.appspot.com',
        iosClientId: 'YOUR_IOS_CLIENT_ID',
        iosBundleId: 'YOUR_IOS_BUNDLE_ID',
      );
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }
}
