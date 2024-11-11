// lib/widgets/custom_bottom_navigation_bar.dart
// ignore_for_file: depend_on_referenced_packages

import 'package:fiander/CONSTANTS/constants.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void updateIndex(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners();
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomBottomNavigationBarProvider>(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: provider.currentIndex,
      selectedItemColor: TextsInsideButtonColor, // Change color when selected
      unselectedItemColor: Colors.black, // Color when not selected
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_outlined),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        if (index == provider.currentIndex) {
          return; // Prevent navigating to the same screen
        }
        provider.updateIndex(index);

        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/events');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/settings');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
        if (kDebugMode) {
          print('Tapped on tab $index');
        }
      },
    );
  }
}
