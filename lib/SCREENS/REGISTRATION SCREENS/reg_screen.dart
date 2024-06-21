import 'package:fiander/COMPONENTS/reuseable_widgets.dart';
import 'package:fiander/CONSTANTS/constants.dart';
import 'package:fiander/SCREENS/REGISTRATION%20SCREENS/email_veri.dart';
import 'package:fiander/SCREENS/REGISTRATION%20SCREENS/password_create.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../onboarding_state.dart';
import 'basic_info.dart';
import 'phone_num_veri.dart';

class RegistrationScreens extends StatefulWidget {
  const RegistrationScreens({Key? key}) : super(key: key);

  @override
  State<RegistrationScreens> createState() => _RegistrationScreensState();
}

class _RegistrationScreensState extends State<RegistrationScreens> {
  // Controller to keep track of the pages
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: const [
              BsicInfoScreen(),
              EmailVerificationScreen(),
              PhoneVerificationScreen(),
              YourPasswordScreen(),
            ],
          ),
          Positioned(
            top: 50.0, // Adjust the top position as needed
            left: 0,
            right: 0,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const slider(),
                      ),
                    );
                  },
                  // onPressed: () {
                  // Navigator.of(context).pop(); // if you i want it to Navigate to previous screen
                  //},
                ),
                const SizedBox(width: 90),
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
