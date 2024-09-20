import 'package:fiander/COMPONENTS/avatar_screens_widget.dart';
import 'package:fiander/SUPABASE/female_dp.dart';
import 'package:flutter/material.dart';

class MaleProfilePicture extends StatelessWidget {
  const MaleProfilePicture({Key? key}) : super(key: key); // Removed required

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
                builder: (context) => const FemaleProfilePicture(),
              ),
            );
          },
        ),
      ),
      body: AvatarSelectionScreen(
        avatarImages: generateAvatarImagePaths(
            'lib/emojis', 14), // Use the path for male avatars
      ),
    );
  }

  // Generate the list of avatar image paths for male avatars
  List<String> generateAvatarImagePaths(String basePath, int count) {
    return List<String>.generate(
        count, (index) => '$basePath/male${index + 1}.png');
  }
}
