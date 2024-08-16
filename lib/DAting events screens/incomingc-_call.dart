import 'dart:math';
import 'package:fiander/CONSTANTS/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IncomingCallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Heart Emojis Background
          Positioned.fill(
            child: HeartEmojiBackground(),
          ),

          // Main Content
          Column(
            mainAxisAlignment: MainAxisAlignment
                .spaceEvenly, // Use space between to distribute content
            children: [
              // Top Center Text
              Padding(
                padding: const EdgeInsets.only(
                    top: 50), // Add padding to move text down
                child: Center(
                  child: Text(
                    "Get Started",
                    style: GoogleFonts.montserrat(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Circle Avatar for User Image
              const CircleAvatar(
                radius: 60.0, // Adjust size as needed
                backgroundImage: AssetImage(
                    'lib/emojis/male12.png'), // Replace with your user image path
              ),
              const SizedBox(
                  height: 20.0), // Adjust space between avatar and slide button
              // Slide to Answer Button
              SlideToAnswerButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class HeartEmojiBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final random = Random();
    return Stack(
      children: List.generate(16, (index) {
        final double top =
            random.nextDouble() * MediaQuery.of(context).size.height;
        final double left =
            random.nextDouble() * MediaQuery.of(context).size.width;
        return Positioned(
          top: top,
          left: left,
          child: Text(
            "❤️",
            style: TextStyle(
              fontSize: 40.0,
              color: TextsInsideButtonColor.withOpacity(0.5),
            ),
          ),
        );
      }),
    );
  }
}

class SlideToAnswerButton extends StatefulWidget {
  @override
  _SlideToAnswerButtonState createState() => _SlideToAnswerButtonState();
}

class _SlideToAnswerButtonState extends State<SlideToAnswerButton> {
  double _dragPosition = 0.0;
  double _maxWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _maxWidth = constraints.maxWidth;
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _dragPosition += details.primaryDelta ?? 0;
              if (_dragPosition > _maxWidth - 60) {
                // Simulate answering the call
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Call Answered!')),
                );
                // Navigate or perform any action to answer the call
              }
            });
          },
          onHorizontalDragEnd: (details) {
            setState(() {
              if (_dragPosition > _maxWidth - 60) {
                _dragPosition =
                    _maxWidth - 60; // Ensure it doesn't go beyond the edge
              } else {
                _dragPosition = 0.0; // Reset position if not fully dragged
              }
            });
          },
          child: Container(
            width: _maxWidth - 10,
            height: 60.0,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0.0,
                  child: Container(
                    width: _maxWidth - 60,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        "Slide to Answer",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: _dragPosition,
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.call,
                      size: 30.0,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
