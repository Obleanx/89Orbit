import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/email_verification_provider.dart';
import 'screens/home_screen.dart';
import 'providers/app_state_provider.dart';

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
          create: (_) => AppStateProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => EmailVerificationProvider(),
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
