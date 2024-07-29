import 'package:fiander/COMPONENTS/avatar_screens_widget.dart';
import 'package:fiander/SCREENS/REGISTRATION%20SCREENS/avatar_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart'; // Import your screen file

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
            final currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FemaleAvatarSelectionScreen(user: currentUser),
                ),
              );
            } else {
              // Handle the case where there is no current user
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No user is currently signed in')),
              );
            }
          },
        ),
      ),
      body: AvatarSelectionScreen(
        avatarImages:
            //this list method generate the images saved in the emoji folder instead of me typing it manually
            generateAvatarImagePaths('lib/emojis', 14),
        user: user,
      ),
    );
  }

//check the reuseable widgets for the logic and design of this screen.
  List<String> generateAvatarImagePaths(String basePath, int count) {
    return List<String>.generate(
        count, (index) => '$basePath/male${index + 1}.png');
  }
}
