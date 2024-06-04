import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display an image in the center
            Image.asset(
                'lib/images/fianderlogo.png'), // Ensure the image is in your assets
          ],
        ),
      ),
    );
  }
}

class HomeScreenLoader extends StatefulWidget {
  @override
  _HomeScreenLoaderState createState() => _HomeScreenLoaderState();
}

class _HomeScreenLoaderState extends State<HomeScreenLoader> {
  bool shouldNavigate = false;

  @override
  void initState() {
    super.initState();
    // Start the timer
    startTimer();
  }

  void startTimer() {
    // Set a timer for 30 seconds
    Future.delayed(Duration(minutes: 30), () {
      // After 30 seconds, set shouldNavigate to true and navigate to OnboardingScreen
      setState(() {
        shouldNavigate = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreen(), // Show the HomeScreen
    );
  }
}
