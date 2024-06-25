import 'package:fiander/COMPONENTS/avatar_screens_widget.dart';
import 'package:flutter/material.dart';

class MaleAvatarSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AvatarSelectionScreen(
      avatarImages: const [
        'assets/male_avatar1.png',
        'assets/male_avatar2.png',
        'assets/male_avatar3.png',
        'assets/male_avatar4.png',
        // Add more male avatar image paths here
      ],
    );
  }
}
