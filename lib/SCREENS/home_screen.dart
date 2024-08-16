import 'package:flutter/material.dart';
import 'onboarding_state.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Display an image in the center
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset('lib/images/fianderlogo.png'),
              ), // Ensure the image is in your lib folder
            ],
          ),
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Start the timer
      startTimer();
    });
  }

  void startTimer() {
    // Set a timer for 20 seconds
    Future.delayed(Duration(seconds: 5), () {
      // Navigate to OnboardingScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const slider()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreen(),
    );
  }
}
