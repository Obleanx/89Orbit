import 'package:fiander/COMPONENTS/avatar_screens_widget.dart';
import 'package:flutter/material.dart';
import '../SCREENS/onboarding_state.dart';

class FemaleProfilePicture extends StatelessWidget {
  const FemaleProfilePicture({
    Key? key,
  }) : super(key: key);

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
        avatarImages: generateAvatarImagePaths('lib/emojis', 15),
      ),
    );
  }

  // Generates image paths dynamically for the avatar selection
  List<String> generateAvatarImagePaths(String basePath, int count) {
    return List<String>.generate(
      count,
      (index) => '$basePath/emoji${index + 1}.png',
    );
  }
}
