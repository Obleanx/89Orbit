import 'package:fiander/COMPONENTS/reuseable_widgets.dart';
import 'package:fiander/CONSTANTS/constants.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/home_screen.dart';
import 'package:fiander/SUPABASE/create_account.dart';
import 'package:fiander/SUPABASE/otp_mobile.dart';
import 'package:fiander/SUPABASE/user_informations.dart';
import 'package:fiander/screens/REGISTRATION%20SCREENS/email_password_screen.dart';
import 'package:fiander/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../SUPABASE/female_dp.dart';
import '../login_screen.dart';
import 'basic_info.dart';
import 'email_veri.dart';
import 'forgot_password.dart';
import 'avatar_profile.dart';
import 'phone_OTP.dart';

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
          // PageView to swipe between screens
          PageView(
            controller: _controller,
            children: [
              CreateAccount(), // Step 1: Email and Password screen
              const UserInformationScreen(),
              const OtpVerificationScreen(), // Step 2: Basic Info screen
              const FemaleProfilePicture(), // Step 3: Email Verification screen
              // OnboardingStepFour(), // Step 4: Phone Verification screen
              const OnboardingStepFive(),
              // Step 5: Avatar selection screen
            ],
          ),
          // Page indicator at the top or bottom

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

// Step 5: Avatar Selection
class OnboardingStepFive extends StatelessWidget {
  const OnboardingStepFive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Select Your Avatar'),
    );
  }
}
