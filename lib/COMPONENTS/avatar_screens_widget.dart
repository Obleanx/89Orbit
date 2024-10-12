import 'package:fiander/CONSTANTS/constants.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/home_screen.dart';
import 'package:fiander/SUPABASE/male_dp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../PROVIDERS/avatar_screen_providers.dart';
import 'pop_message.dart';

class AvatarSelectionScreen extends StatelessWidget {
  final List<String> avatarImages;

  AvatarSelectionScreen({
    required this.avatarImages,
  });

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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MaleProfilePicture(),
                      ),
                    );
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
                    child: const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose an avatar that best describes you',
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
                    _handleAvatarSelection(context, selectedAvatar);
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

  Future<void> _handleAvatarSelection(
      BuildContext context, String selectedAvatar) async {
    final navigatorState = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Show loading indicator
    navigatorState.push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) =>
          const Center(child: CircularProgressIndicator()),
    ));

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null || user.email == null) {
        throw Exception('User not authenticated or email is null.');
      }

      final response = await Supabase.instance.client
          .from('verified_user_details')
          .update({'avatar': selectedAvatar})
          .eq('email', user.email as Object)
          .select()
          .single();

      if (response == null) {
        throw Exception('No data returned from the database.');
      }

      // Remove loading indicator
      navigatorState.pop();

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Avatar selected and saved successfully')),
      );

      // Navigate to the next screen
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return FriendlySuccessDialog(
            message: 'Avatar selected and saved successfully!',
            onClose: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen1()),
              );
            },
          );
        },
      );
    } catch (e) {
      // Remove loading indicator
      navigatorState.pop();

      if (kDebugMode) {
        print('Error: $e');
      }

      String errorMessage = 'Failed to save avatar';
      if (e is PostgrestException) {
        errorMessage += ': ${e.message}';
      } else if (e is Exception) {
        errorMessage += ': ${e.toString()}';
      }

      // Show error in a friendly dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Oops!'),
            content: Text(errorMessage),
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
  }
}
