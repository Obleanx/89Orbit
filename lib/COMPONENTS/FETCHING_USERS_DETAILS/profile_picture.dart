import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Avatar$username extends StatefulWidget {
  const Avatar$username({super.key});

  @override
  _Avatar$usernameState createState() => _Avatar$usernameState();
}

class _Avatar$usernameState extends State<Avatar$username> {
  String? userName;
  String? avatarAsset;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null && user.email != null) {
        if (kDebugMode) {
          print('Fetching data for user email: ${user.email}');
        }

        final response = await Supabase.instance.client
            .from('verified_user_details')
            .select('name, avatar')
            .eq('email', user.email as Object)
            .single();

        if (kDebugMode) {
          print('Supabase response: $response');
        }

        setState(() {
          userName = response['name'] as String?;
          avatarAsset = response['avatar'] as String?;
          isLoading = false;
        });

        if (kDebugMode) {
          print('Username: $userName, Avatar: $avatarAsset');
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
    return isLoading
        ? const CircularProgressIndicator()
        : Padding(
            padding: const EdgeInsets.only(left: 13),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: avatarAsset != null
                      ? AssetImage(avatarAsset!)
                      : const AssetImage('lib/images/default_avatar.png'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName != null ? ' $userName' : 'Hi welcome back...',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      EventRegistrationStatus(),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class EventRegistrationStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement this widget based on your requirements
    return const Text('Event Registration Status');
  }
}
