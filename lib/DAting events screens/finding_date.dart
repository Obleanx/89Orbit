import 'package:fiander/CONSTANTS/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../ZegoCloud/call screen.dart';
import 'incomingc-_call.dart';
import 'pop_messages.dart';

class LoadingScreenProvider extends ChangeNotifier {
  // Any state management logic for loading can be added here
}

class FindingDateLoadingScreen extends StatelessWidget {
  const FindingDateLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoadingScreenProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Concentric Circles
                  for (int i = 1; i <= 4; i++)
                    CircleAvatar(
                      radius: i * 60.0, // Adjust the size of each circle
                      backgroundColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: TextsInsideButtonColor.withOpacity(0.2),
                            width: 1.0,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                  // Image at the Center
                  Image.asset(
                    'lib/emojis/date1.png',
                    height: 60.0, // Adjust the size of the image
                    width: 60.0,
                  ),

                  // Planetary Circle Avatars
                  const Positioned(
                    top:
                        47.0, // Adjust the position based on your circle radius
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 15.0,
                    ),
                  ),
                  const Positioned(
                    left:
                        47.0, // Adjust the position based on your circle radius
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 15.0,
                    ),
                  ),
                  const Positioned(
                    right:
                        47.0, // Adjust the position based on your circle radius
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 15.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 40.0), // Space between the circle and the text
              const BlinkingText(),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const PopupMessage(),
                        );
                      },
                      style: elevatedButtonDesign,
                      child: const Text(
                        "show pop",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallPage(
                            callID: '',
                            eventType: '',
                            eventDate: '',
                            callDurationInMinutes: 3,
                          ),
                        ),
                      );
                    },
                    style: elevatedButtonDesign,
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Loading Text with Dot Indicator class
class BlinkingText extends StatelessWidget {
  const BlinkingText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "finding a date",
          style: GoogleFonts.montserrat(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlueAccent,
          ),
        ),
        const SizedBox(width: 10.0), // Spacing between the text and the loader
        const SpinKitThreeBounce(
          color: TextsInsideButtonColor,
          size: 20.0,
        ),
      ],
    );
  }
}
