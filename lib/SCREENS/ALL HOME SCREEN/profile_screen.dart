import 'package:fiander/COMPONENTS/setting_listitems.dart';
import 'package:fiander/CONSTANTS/constants.dart';
import 'package:fiander/PROVIDERS/settings_screen_provider.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/event_history.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/home_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsProvider>(
      create: (_) => SettingsProvider(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: TextColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    // ignore: prefer_const_constructors
                    builder: (context) => HomeScreen1(),
                  ));
            },
          ),
          title: const Text(
            'Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 250,
                    decoration: const BoxDecoration(
                      color: TextColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  const Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage(
                            'lib/emojis/emoji3.png'), // Update with your asset
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Consumer<SettingsProvider>(
                      builder: (context, provider, child) {
                        return Text(
                          provider.userLocation ?? 'Location not available',
                          style: const TextStyle(color: Colors.black),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingsListItem(
                      title: 'Event history',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              // ignore: prefer_const_constructors
                              builder: (context) => EventHistoryScreen(),
                            ));
                      },
                    ),
                    SettingsListItem(
                      title: 'Edit profile',
                      onTap: () {
                        // Handle Blog tap
                      },
                    ),
                    SettingsListItem(
                      title: 'settings',
                      onTap: () {
                        // Handle Blog tap
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
