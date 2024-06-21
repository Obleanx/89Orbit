import 'package:flutter/material.dart';
import '../CONSTANTS/constants.dart';
import 'REGISTRATION SCREENS/reg_screen.dart';

class OnboardingPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/images/fiander9.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 230),
                ),
                const SizedBox(height: 55),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 300),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationScreens()),
                          );
                        },
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            color: NormalTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'Login with phone number',
                        style: TextStyle(
                          color: TextsInsideButtonColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Center(
                      child: Text(
                        'Terms of Service',
                        style: TextStyle(
                          color: NormalTextColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 110,
                      child: Divider(
                        height: 5,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'By signing in or create an account you have agreed to fianDer\n                                     terms and services',
                        style: TextStyle(color: NormalTextColor, fontSize: 10),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
