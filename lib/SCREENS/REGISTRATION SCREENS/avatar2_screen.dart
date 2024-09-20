import 'package:fiander/COMPONENTS/avatar_screens_widget.dart';
import 'package:fiander/SCREENS/REGISTRATION%20SCREENS/avatar_profile.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Still needed for the User object
import 'package:flutter/material.dart';

class MaleAvatarSelectionScreen extends StatelessWidget {
  final User user;

  const MaleAvatarSelectionScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FemaleAvatarSelectionScreen(
                  user: user,
                  setCurrentUser: (User? user) {},
                ), // Use the user passed to the widget
              ),
            );
          },
        ),
      ),
      body: AvatarSelectionScreen(
        avatarImages:
            // This list method generates the images saved in the emoji folder instead of typing it manually
            generateAvatarImagePaths('lib/emojis', 14),
      ),
    );
  }

  // Generate the list of avatar image paths
  List<String> generateAvatarImagePaths(String basePath, int count) {
    return List<String>.generate(
        count, (index) => '$basePath/male${index + 1}.png');
  }
}
