// ignore_for_file: depend_on_referenced_packages
import 'package:fiander/PROVIDERS/app_state_provider.dart';
import 'package:fiander/PROVIDERS/atm_idetails.dart';
import 'package:fiander/PROVIDERS/avatar_screen_providers.dart';
import 'package:fiander/PROVIDERS/create_account_provider.dart';
import 'package:fiander/PROVIDERS/home_screen_provider.dart';
import 'package:fiander/PROVIDERS/login_screen_provider.dart';
import 'package:fiander/PROVIDERS/pay_popup_provider.dart';
import 'package:fiander/PROVIDERS/settings_screen_provider.dart';
import 'package:fiander/PROVIDERS/user_preference_provider.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/events_screen.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/home_screen.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/nav_bar.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/profile_screen.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/settings_screen.dart';
import 'package:fiander/SCREENS/home_screen.dart';
import 'package:fiander/SERVICES/firebase_API.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'SERVICES/firebase_service.dart';
import 'SERVICES/onesignal_services.dart';
import 'SERVICES/supabase_service.dart';
import 'SERVICES/zegocloud_service.dart';

/// 1.1.1 Define a navigator key
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Show loading screen immediately
  runApp(const LoadingApp());

  try {
    // Step 1: Initialize Flutter bindings
    if (kDebugMode) print("Step 1: Initializing WidgetsFlutterBinding");
    WidgetsFlutterBinding.ensureInitialized();

    // Step 2: Initialize Firebase
    if (kDebugMode) print("Step 2: Initializing Firebase");
    await FirebaseService.initialize();

    // Step 3: Initialize OneSignal
    if (kDebugMode) print("Step 3: Initializing OneSignal");
    await OneSignalService.initialize();

    // Step 4: Initialize Supabase
    if (kDebugMode) print("Step 4: Initializing Supabase");
    await SupabaseService.initialize();

    // Step 5: Initialize Zego
    if (kDebugMode) print("Step 5: Initializing Zego");
    await ZegoService.initialize(navigatorKey);

    // Step 6: Launch main app
    if (kDebugMode) print("Step 6: Launching main app");
    runApp(MyApp(navigatorKey: navigatorKey));
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print("Error during initialization: $e");
      print("Stack trace: $stackTrace");
    }
  }
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({super.key, required this.navigatorKey});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // providers here
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => AvatarSelectionProvider()),
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ChangeNotifierProvider(
            create: (_) => CustomBottomNavigationBarProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => EventAccessNotifier()),
        ChangeNotifierProvider(create: (_) => CardProvider()),
        ChangeNotifierProvider(create: (_) => UserPreferencesProvider()),
        ChangeNotifierProvider(
          create: (_) => CreateAccountProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        /// 1.1.3 Register the navigator key to MaterialApp
        navigatorKey: widget.navigatorKey,

        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
        ),

        home: HomeScreenLoader(),
        routes: {
          '/home': (context) => const HomeScreen1(),
          '/events': (context) => const EventsScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}

//physics: const NeverScrollableScrollPhysics(), // Disable sliding
//physics: const NeverScrollableScrollPhysics(), // Disable sliding
//physics: const NeverScrollableScrollPhysics(), // Disable sliding
//add it in the page view of smooth page indicator



