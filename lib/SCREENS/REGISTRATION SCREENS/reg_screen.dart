import 'package:fiander/COMPONENTS/reuseable_widgets.dart';
import 'package:fiander/CONSTANTS/constants.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/home_screen.dart';
import 'package:fiander/screens/REGISTRATION%20SCREENS/email_password_screen.dart';
import 'package:fiander/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'basic_info.dart';
import 'email_veri.dart';
import 'forgot_password.dart';
import 'avatar_profile.dart';
import 'phone_OTP.dart';

class RegistrationScreens extends StatefulWidget {
  const RegistrationScreens({Key? key}) : super(key: key);

  @override
  State<RegistrationScreens> createState() => _RegistrationScreensState();
}

class _RegistrationScreensState extends State<RegistrationScreens> {
  // Controller to keep track of the pages
  final PageController _controller = PageController();
  User? currentUser; // Nullable User variable to hold logged-in user

  // Method to set the logged-in user
  void setCurrentUser(User? user) {
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
              controller: _controller,
              //physics: const NeverScrollableScrollPhysics(), // Disable sliding

              children: [
                EmailandPassword(setCurrentUser: setCurrentUser),
                if (currentUser != null) BsicInfoScreen(user: currentUser!),
                if (currentUser != null)
                  EmailVerificationScreen(user: currentUser!),
                if (currentUser != null)
                  PhoneVerificationScreen(
                    user: currentUser!,
                  ),
                if (currentUser != null)
                  FemaleAvatarSelectionScreen(user: currentUser!)
              ]),
          Positioned(
            top: 50.0, // Adjust the top position as needed
            left: 0,
            right: 0,
            child: Row(
              children: [
                const SizedBox(width: 125),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: CustomTickEffect(
                    tickIcon: Icons.check,
                    tickColor: Colors.white,
                    dotWidth: 13,
                    dotHeight: 13,
                    dotColor: TextsInsideButtonColor,
                    activeDotColor: Colors.blue,
                    spacing: 15.0,
                    radius: 10.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
