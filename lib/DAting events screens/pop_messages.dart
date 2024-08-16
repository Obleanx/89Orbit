import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopupMessage extends StatelessWidget {
  const PopupMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      content: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Notification Icon with Glowing Effect
            Stack(
              alignment: Alignment.center,
              children: [
                // Glowing Effect
                Positioned(
                  child: Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.2),
                    ),
                  ),
                ),
                const Icon(
                  Icons.notifications,
                  size: 40.0,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 16.0), // Space between icon and text

            // Heading Text
            Text(
              "Round 1: Initial Connection",
              style: GoogleFonts.montserrat(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
                height: 8.0), // Space between heading and description

            // Description Text
            Text(
              "Start making connections. You have 2 minutes audio call with potential matches. Make a great first impression and enjoy the conversations.",
              style: GoogleFonts.montserrat(
                fontSize: 14.0,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
                height: 16.0), // Space between description and button

            // Elevated Button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Pop the screen
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 8,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
              ),
              child: const Text("Okay"),
            ),
          ],
        ),
      ),
    );
  }
}
