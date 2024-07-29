import 'package:fiander/CONSTANTS/constants.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../PROVIDERS/avatar_screen_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../SCREENS/REGISTRATION SCREENS/avatar2_screen.dart';

class AvatarSelectionScreen extends StatelessWidget {
  final List<String> avatarImages;
  final User user;

  AvatarSelectionScreen({required this.avatarImages, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Select your avatar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MaleAvatarSelectionScreen(user: currentUser),
                        ),
                      );
                    } else {
                      // Handle the case where there is no current user
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content:
                                const Text('No user is currently signed in'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.6), // Glowing color
                          spreadRadius: 5,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        final currentUser = FirebaseAuth.instance.currentUser;
                        if (currentUser != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MaleAvatarSelectionScreen(user: currentUser),
                            ),
                          );
                        } else {
                          // Handle the case where there is no current user
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text(
                                    'No user is currently signed in'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      icon: const Icon(Icons.keyboard_arrow_right,
                          color:
                              Colors.blue), // Choose the desired icon and color
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'choose an avatar that best describes you',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<AvatarSelectionProvider>(
                builder: (context, provider, child) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 40.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1,
                    ),
                    itemCount: avatarImages.length,
                    itemBuilder: (context, index) {
                      bool isSelected =
                          provider.selectedAvatar == avatarImages[index];
                      return GestureDetector(
                        onTap: () {
                          provider.selectAvatar(avatarImages[index]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: isSelected
                                ? Border.all(color: Colors.blue, width: 3)
                                : null,
                            image: DecorationImage(
                              image: AssetImage(avatarImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
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
                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );

                    try {
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({'profileImage': selectedAvatar});

                        // Dismiss loading indicator
                        Navigator.of(context).pop();

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Profile image updated successfully')),
                        );

                        // Navigate to home screen
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen1()), // Replace with your actual home screen
                        );
                      } else {
                        throw Exception('No user logged in');
                      }
                    } catch (e) {
                      // Dismiss loading indicator
                      Navigator.of(context).pop();

                      // Show error message
                      print('Error updating profile image: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to update profile image')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select an avatar')),
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
