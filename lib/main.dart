import 'package:fiander/PROVIDERS/avatar_screen_providers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'PROVIDERS/app_state_provider.dart' as uppercase;
import 'providers/email_verification_provider.dart';
import 'screens/home_screen.dart'; // Ensure this is imported correctly

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => uppercase.AppStateProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => EmailVerificationProvider(),
        ),
        ChangeNotifierProvider<AvatarSelectionProvider>(
          create: (_) => AvatarSelectionProvider(),
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
      ),
    );
  }
}
