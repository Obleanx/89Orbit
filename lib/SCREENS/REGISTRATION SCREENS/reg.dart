import 'package:fiander/COMPONENTS/reuseable_widgets.dart';
import 'package:fiander/CONSTANTS/constants.dart';
import 'package:fiander/SUPABASE/create_account.dart';
import 'package:fiander/SUPABASE/otp_mobile.dart';
import 'package:fiander/SUPABASE/user_informations.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../SUPABASE/female_dp.dart';

class RegistrationScreens extends StatefulWidget {
  const RegistrationScreens({Key? key}) : super(key: key);

  @override
  _RegistrationScreensState createState() => _RegistrationScreensState();
}

class _RegistrationScreensState extends State<RegistrationScreens> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView to swipe between screens during onboarding and registration
          PageView(
            controller: _controller,
            children: [
              CreateAccount(), // Step 1: Email and Password screen// Step 3: Email Verification screen
              const UserInformationScreen(), // Step 2: Basic Info screen
              const OtpVerificationScreen(), // Step 3: Phone Verification screen
              const FemaleProfilePicture(), // Step 4: Avatar selection screen
              //the the user logins in to the home screen. Shekina!!
            ],
          ),
          // Page indicator at the top

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
