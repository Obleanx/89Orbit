import 'package:fiander/COMPONENTS/avatar_screens_widget.dart';
import 'package:flutter/material.dart'; // Import your screen file

class FemaleAvatarSelectionScreen extends StatelessWidget {
  const FemaleAvatarSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
