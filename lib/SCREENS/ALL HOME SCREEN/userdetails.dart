// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../DATE_MATHCHING/preference_section.dart';
import '../../DAting events screens/finding_date.dart';

class UserPreferencesScreen extends StatefulWidget {
  const UserPreferencesScreen({Key? key}) : super(key: key);

  @override
  _UserPreferencesScreenState createState() => _UserPreferencesScreenState();
}

class _UserPreferencesScreenState extends State<UserPreferencesScreen> {
  // Centralized state to store user selections for each section
  final Map<String, List<String>> _userSelections = {};
  bool _isLoading = false; // Define the _isLoading variable

  // This function will handle updating the selections for each category
  void _updateSelections(String category, List<String> selections) {
    setState(() {
      _userSelections[category] = selections;
      // Debugging: Print updated selections after state change
      if (kDebugMode) {
        print('Updated selections for $category: ${_userSelections[category]}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tell us more about you',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Let\'s help you find a perfect match',
                style: TextStyle(fontSize: 16),
              ),
              const Divider(),
              PreferenceSection(
                title: 'Ethnicity/Tribe',
                items: const ['Yoruba', 'Igbo', 'Hausa', 'Others'],
                maxSelection: 1,
                onSelectionChanged: (selections) =>
                    _updateSelections('Ethnicity/Tribe', selections),
              ),
              PreferenceSection(
                title: 'Religion',
                items: const ['Christianity', 'Islam', 'Others'],
                maxSelection: 1,
                onSelectionChanged: (selections) =>
                    _updateSelections('Religion', selections),
              ),
              PreferenceSection(
                title: 'Education Level',
                items: const [
                  'Diploma',
                  'Bachelor degree',
                  'Masters',
                  'PhD/Doctorate',
                  'Others'
                ],
                maxSelection: 3,
                onSelectionChanged: (selections) =>
                    _updateSelections('Education Level', selections),
              ),
              PreferenceSection(
                title: 'Region',
                items: const [
                  'West',
                  'East',
                  'South-South',
                  'North Central',
                  'North East',
                  'South West'
                ],
                maxSelection: 1,
                onSelectionChanged: (selections) =>
                    _updateSelections('Region', selections),
              ),
              PreferenceSection(
                title: 'Hobbies and Interest',
                items: const [
                  'Racing',
                  'Travelling',
                  'Sports',
                  'Music',
                  'Cooking',
                  'Gaming',
                  'Fashion',
                  'Movies/TV Shows',
                  'Others'
                ],
                maxSelection: 5,
                minSelection: 2,
                onSelectionChanged: (selections) =>
                    _updateSelections('Hobbies and Interest', selections),
              ),
              PreferenceSection(
                title: 'Age Range',
                // ignore: prefer_const_literals_to_create_immutables
                items: [
                  '23-30',
                  '30-35',
                  '36-40',
                  '41-46',
                  '47-55',
                  '56 and above'
                ],
                maxSelection: 1,
                onSelectionChanged: (selections) =>
                    _updateSelections('Age Range', selections),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => _submitPreferences(context),
                  child: const Text('Submit Preferences'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitPreferences(BuildContext context) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      _showErrorDialog(
          context, 'User is not authenticated. Please log in and try again.');
      return;
    }

    // Define the required categories
    final requiredCategories = [
      'Religion',
      'Region',
      'Ethnicity/Tribe',
      'Education Level',
      'Age Range',
      'Hobbies and Interest'
    ];

    // Check if all required categories have at least one selection
    for (String category in requiredCategories) {
      if (_userSelections[category] == null ||
          _userSelections[category]!.isEmpty) {
        _showErrorDialog(context,
            'Please make a selection for $category before submitting.');
        return;
      }
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Fetch gender from verified_user_details table
      final verifiedUserDetails = await supabase
          .from('verified_user_details')
          .select('gender')
          ////// .eq('user_id', user.id) don't use the user_id because in the verified user table in the backend, I used the email as the only unique identifier for each row belonging to a particular user if you use it it will throw an error.
          .single();

      String gender = verifiedUserDetails['gender'] ?? '';

      // Insert the user preferences into the Supabase table
      final response = await supabase.from('user_preferences').insert({
        'user_id': user.id,
        'religion': _userSelections['Religion']?.first ?? '',
        'region': _userSelections['Region']?.first ?? '',
        'ethnicity': _userSelections['Ethnicity/Tribe']?.first ?? '',
        'education_level': _userSelections['Education Level'] ?? [],
        'age_range': _userSelections['Age Range']?.first ?? '',
        'gender':
            gender, // Use the fetched gender from the verified_user_details table
        'hobbies': _userSelections['Hobbies and Interest'] ?? [],
      }).select();

      // Close loading indicator
      Navigator.of(context).pop();

      if (response != null && response.isNotEmpty) {
        // Show success dialog
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content:
                  const Text('Your preferences have been successfully saved.'),
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

        // Navigate to LoadingScreenProvider
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => FindingDateLoadingScreen()),
        );
      } else {
        _showErrorDialog(
            context, 'Failed to save preferences. Please try again.');
      }
    } catch (e) {
      // Close loading indicator
      Navigator.of(context).pop();
      _showErrorDialog(context, 'An unexpected error occurred: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
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
