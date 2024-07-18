import 'package:fiander/CONSTANTS/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../PROVIDERS/avatar_screen_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvatarSelectionScreen extends StatelessWidget {
  final List<String> avatarImages;

  AvatarSelectionScreen({required this.avatarImages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // elevation: 0,
          // backgroundColor: Colors.transparent,
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your avatar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'choose an avatar that best describes you',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 40.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1,
                ),
                itemCount: avatarImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      Provider.of<AvatarSelectionProvider>(context,
                              listen: false)
                          .selectAvatar(avatarImages[index]);

                      // Update Firestore
                      try {
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .update({'profileImage': avatarImages[index]});

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Avatar selected and updated')),
                          );
                        }
                      } catch (e) {
                        print('Error updating avatar: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update avatar')),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage(avatarImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final selectedAvatar = Provider.of<AvatarSelectionProvider>(
                          context,
                          listen: false)
                      .selectedAvatar;
                  if (selectedAvatar != null) {
                    try {
                      // Get the current user
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        // Update the user's profile in Firestore
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({'profileImage': selectedAvatar});

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Profile image updated successfully')),
                        );

                        // Navigate to the next screen or perform any other action
                        // For example:
                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NextScreen()));
                      } else {
                        throw Exception('No user logged in');
                      }
                    } catch (e) {
                      // Handle any errors
                      print('Error updating profile image: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to update profile image')),
                      );
                    }
                  } else {
                    // Handle no avatar selected case
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select an avatar')),
                    );
                  }
                },
                style: elevatedButtonDesign,
                child: const Text(
                  'Let\'s get started',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
