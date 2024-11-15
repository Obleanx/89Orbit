import 'package:fiander/COMPONENTS/setting_listitems.dart';
import 'package:fiander/CONSTANTS/constants.dart';
import 'package:fiander/PROVIDERS/settings_screen_provider.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/event_history.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? location;
  String? avatarAsset;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

//fetches the user informations from the data base
  Future<void> _fetchUserData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null && user.email != null) {
        if (kDebugMode) {
          print('Fetching data for user email: ${user.email}');
        }

        final response = await Supabase.instance.client
            .from('verified_user_details')
            .select('location, avatar')
            .eq('email', user.email as Object)
            .single();

        if (kDebugMode) {
          print('Supabase response: $response');
        }

        setState(() {
          location = response['location'] as String?;
          avatarAsset = response['avatar'] as String?;
          isLoading = false;
        });

        if (kDebugMode) {
          print('Location: $location, Avatar: $avatarAsset');
        }
      } else {
        throw Exception('User not logged in or email not available');
      }
    } on PostgrestException catch (e) {
      if (kDebugMode) {
        print('PostgrestException: ${e.message}');
      }
      if (kDebugMode) {
        print('Details: ${e.details}');
      }
      if (kDebugMode) {
        print('Hint: ${e.hint}');
      }
      _showErrorDialog('Database error: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
      _showErrorDialog('Failed to fetch user data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

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
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 70,

                        backgroundImage: avatarAsset != null
                            ? AssetImage(avatarAsset!)
                            : const AssetImage(
                                'lib/images/emoji5.png'), // Update with your asset
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Consumer<SettingsProvider>(
                      builder: (context, provider, child) {
                        return Text(
                          location != null
                              ? ' $location'
                              : 'location not available...',
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                        // Example of how to use the screen
                        final currentUser =
                            Supabase.instance.client.auth.currentUser;
                        if (currentUser != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventHistoryScreen(
                                userId: currentUser.id,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    SettingsListItem(
                      title: 'Edit profile',
                      onTap: () {
                        // Handle Blog tap
                      },
                    ),
                    // SettingsListItem(
                    // title: 'settings',
                    // onTap: () {
                    // Handle Blog tap
                    // },
                    // ),
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
