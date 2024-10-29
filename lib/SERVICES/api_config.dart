import 'package:firebase_core/firebase_core.dart';

class APIConfig {
  // Firebase Configuration
  static const firebaseConfig = FirebaseOptions(
    apiKey: 'AIzaSyAwUcWebG7X2ny1fJk1VRGjRSSAlBF8-1Y',
    appId: '1:472021146803:android:5a075b9e6e91efd6d024c6',
    messagingSenderId: '472021146803',
    projectId: 'fiander-bf964',
    storageBucket: 'fiander-bf964.appspot.com',
  );

  // OneSignal Configuration
  static const oneSignalAppId = '9c4360af-6207-4194-a24c-2b85d9820694';

  // Supabase Configuration
  static const supabaseUrl = 'https://shcwsfoylsjakwlezini.supabase.co';
  static const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNoY3dzZm95bHNqYWt3bGV6aW5pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjY1ODI1NzksImV4cCI6MjA0MjE1ODU3OX0.FlDFdkVRTaAna_MycZ0b4p5Y2HieXEwXzkmu0vTJD-E';
}
