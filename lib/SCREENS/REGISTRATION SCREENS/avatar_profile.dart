import 'package:fiander/COMPONENTS/avatar_screens_widget.dart';
import 'package:flutter/material.dart';

import '../onboarding_state.dart'; // Import your screen file

class FemaleAvatarSelectionScreen extends StatelessWidget {
  const FemaleAvatarSelectionScreen({super.key});

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
              MaterialPageRoute(builder: (context) => const slider()),
            ); // Adjust route as needed
          },
        ),
      ),
      body: AvatarSelectionScreen(
        avatarImages:
            //this list method generate the images saved in the emoji folder instead of me typing it manually
            generateAvatarImagePaths('lib/emojis', 15),
      ),
    );
  }

//check the reuseable widgets for the logic and design of this screen.
  List<String> generateAvatarImagePaths(String basePath, int count) {
    return List<String>.generate(
        count, (index) => '$basePath/emoji${index + 1}.png');
  }
}
