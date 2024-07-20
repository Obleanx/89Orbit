import 'package:fiander/SCREENS/login_screen.dart';
import 'package:flutter/material.dart';
import '../CONSTANTS/constants.dart';
import 'REGISTRATION SCREENS/reg_screen.dart';

class OnboardingPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(
      // backgroundColor: Colors.transparent,
      //  ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/images/fiander1.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 230),
                  child: Text(
                    '  Your  spouse awaits you',
                    style: TextStyle(
                      color: NormalTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 45),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 250),
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginWithPhonenumber()),
                        );
                      },
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
                        'Terme of Service',
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
                        //leave the space in this text the way it is please!!
                        'By signing in or create an account you have agreed to fianDer\n                                       terms and services',
                        style: TextStyle(color: NormalTextColor, fontSize: 10),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
