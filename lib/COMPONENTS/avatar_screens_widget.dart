import 'package:fiander/CONSTANTS/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../PROVIDERS/avatar_screen_providers.dart';

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
              'Choose your avatar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select an avatar that best describes you',
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
                    onTap: () {
                      Provider.of<AvatarSelectionProvider>(context,
                              listen: false)
                          .selectAvatar(avatarImages[index]);
                      // Handle the backend logic here if needed
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
                onPressed: () {
                  final selectedAvatar = Provider.of<AvatarSelectionProvider>(
                          context,
                          listen: false)
                      .selectedAvatar;
                  if (selectedAvatar != null) {
                    // Handle button press, e.g., send selectedAvatar to backend
                    if (kDebugMode) {
                      print('Selected avatar: $selectedAvatar');
                    }
                  } else {
                    // Handle no avatar selected case
                    if (kDebugMode) {
                      print('No avatar selected');
                    }
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
