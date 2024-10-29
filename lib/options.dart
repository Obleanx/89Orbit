import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (const bool.fromEnvironment('dart.vm.product')) {
      // Release mode (use default production configuration)
      return const FirebaseOptions(
        apiKey: 'AIzaSyAwUcWebG7X2ny1fJk1VRGjRSSAlBF8-1Y',
        appId: '1:472021146803:android:5a075b9e6e91efd6d024c6',
        messagingSenderId: '472021146803',
        projectId: 'fiander-bf964',
        storageBucket: 'fiander-bf964.appspot.com',
      );
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      // Android configuration
      return const FirebaseOptions(
        apiKey: 'AIzaSyAwUcWebG7X2ny1fJk1VRGjRSSAlBF8-1Y',
        appId: '1:472021146803:android:5a075b9e6e91efd6d024c6',
        messagingSenderId: '472021146803',
        projectId: 'fiander-bf964',
        storageBucket: 'fiander-bf964.appspot.com',
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS configuration
      return const FirebaseOptions(
        apiKey: 'AIzaSyD99ApVo7Mq-2WJKA8brJZ7dsOpC0hhjd8',
        appId: '1:472021146803:ios:3edeea96422684f3d024c6',
        messagingSenderId: '472021146803',
        projectId: 'fiander-bf964',
        storageBucket: 'fiander-bf964.appspot.com',
        iosClientId:
            'YOUR_IOS_CLIENT_ID', // Replace if you have a specific value
        iosBundleId: 'com.example.fiander',
      );
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }
}
