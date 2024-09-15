import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxk-u8832h1pCo7p61J5jmY-HduUSn5zI',
    appId: '1:1009241858448:android:5a5c28bf3cfe233bd95315',
    messagingSenderId: '1009241858448',
    projectId: 'fiander',
    storageBucket: 'fiander.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBfK6h8JbtHrJaqpAVRJgsVZA9iF4ZDroI',
    appId: '1:1009241858448:ios:5dee08a818a3a144d95315',
    messagingSenderId: '1009241858448',
    projectId: 'fiander',
    storageBucket: 'fiander.appspot.com',
    iosClientId:
        'YOUR_IOS_CLIENT_ID', // try make you Replace this line with actual iOS client ID when available
    iosBundleId: 'com.example.fiander.RunnerTests', // From your iOS plist
  );
}
