import 'package:fiander/SCREENS/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'PROVIDERS/app_state_provider.dart' as uppercase;
import 'PROVIDERS/avatar_screen_providers.dart';
import 'PROVIDERS/home_screen_provider.dart';
import 'PROVIDERS/pay_popup_provider.dart';
import 'PROVIDERS/atm_idetails.dart';
import 'PROVIDERS/login_screen_provider.dart';
import 'PROVIDERS/settings_screen_provider.dart';
import 'SCREENS/ALL HOME SCREEN/home_screen.dart';
import 'SCREENS/ALL HOME SCREEN/nav_bar.dart';
import 'SCREENS/ALL HOME SCREEN/profile_screen.dart';
import 'SCREENS/ALL HOME SCREEN/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const MyApp());
}

Future<void> initializeFirebase() async {
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
    // You might want to show an error dialog or handle this error appropriately
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => uppercase.AppStateProvider()),
        ChangeNotifierProvider<AvatarSelectionProvider>(
            create: (_) => AvatarSelectionProvider()),
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ChangeNotifierProvider(
            create: (_) => CustomBottomNavigationBarProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => EventAccessNotifier()),
        ChangeNotifierProvider(create: (_) => CardProvider()),
      ],
      child: MaterialApp(
        routes: {
          '/home': (context) => HomeScreen1(),
          '/events': (context) => const EventsScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: HomeScreenLoader(),
      ),
    );
  }
}
