import 'package:fiander/SCREENS/onboarding_page2.dart';
import 'package:fiander/SCREENS/onboarding_page3.dart';
import 'package:fiander/screens/onboarding_page1.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../CONSTANTS/constants.dart';

class slider extends StatefulWidget {
  const slider({Key? key}) : super(key: key);

  @override
  State<slider> createState() => _sliderState();
}

class _sliderState extends State<slider> {
  // Controller to keep track of the pages
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              OnboardingPage1(),
              OnboardingPage2(),
              OnboardingPage3(),
            ],
          ),
          Positioned(
            top: 50.0, // Adjust the top position as needed
            left: 0,
            right: 0,
            child: Center(
              heightFactor: 4,
              widthFactor: 600,
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const WormEffect(
                  dotWidth: 70, // Set the width of the indicator
                  dotHeight: 4, // Set the height of the indicator
                  dotColor: Color(0xff5c6972), // Set the color of the indicator
                  activeDotColor:
                      NormalTextColor, // Set the color of the active indicator
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
