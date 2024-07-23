import 'package:fiander/COMPONENTS/avatar_screens_widget.dart';
import 'package:fiander/SCREENS/REGISTRATION%20SCREENS/avatar_profile.dart';
import 'package:flutter/material.dart'; // Import your screen file

class MaleAvatarSelectionScreen extends StatelessWidget {
  const MaleAvatarSelectionScreen({super.key});

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
                  builder: (context) => const FemaleAvatarSelectionScreen()),
            );
          },
        ),
      ),
      body: AvatarSelectionScreen(
        avatarImages:
            //this list method generate the images saved in the emoji folder instead of me typing it manually
            generateAvatarImagePaths('lib/emojis', 14),
      ),
    );
  }

//check the reuseable widgets for the logic and design of this screen.
  List<String> generateAvatarImagePaths(String basePath, int count) {
    return List<String>.generate(
        count, (index) => '$basePath/male${index + 1}.png');
  }
}
