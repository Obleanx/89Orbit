import 'package:fiander/PROVIDERS/app_state_provider.dart';
import 'package:fiander/PROVIDERS/atm_idetails.dart';
import 'package:fiander/PROVIDERS/avatar_screen_providers.dart';
import 'package:fiander/PROVIDERS/home_screen_provider.dart';
import 'package:fiander/PROVIDERS/login_screen_provider.dart';
import 'package:fiander/PROVIDERS/pay_popup_provider.dart';
import 'package:fiander/PROVIDERS/settings_screen_provider.dart';
import 'package:fiander/PROVIDERS/user_preference_provider.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/home_screen.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/nav_bar.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/profile_screen.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/settings_screen.dart';
import 'package:fiander/SCREENS/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://shcwsfoylsjakwlezini.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNoY3dzZm95bHNqYWt3bGV6aW5pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjY1ODI1NzksImV4cCI6MjA0MjE1ODU3OX0.FlDFdkVRTaAna_MycZ0b4p5Y2HieXEwXzkmu0vTJD-E',
  );
  runApp(const MyApp());
}

// It's handy to then extract the Supabase client in a variable for later uses
final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Your providers here
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider<AvatarSelectionProvider>(
            create: (_) => AvatarSelectionProvider()),
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ChangeNotifierProvider(
            create: (_) => CustomBottomNavigationBarProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => EventAccessNotifier()),
        ChangeNotifierProvider(create: (_) => CardProvider()),
        ChangeNotifierProvider(
          create: (_) => UserPreferencesProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: HomeScreenLoader(),
        routes: {
          '/home': (context) => HomeScreen1(),
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


