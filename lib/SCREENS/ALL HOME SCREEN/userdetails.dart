import 'package:fiander/CONSTANTS/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../PROVIDERS/userdetail_provider.dart';

class UserPreferencesScreen extends StatelessWidget {
  const UserPreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserPreferencesProvider(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Tell us more about you',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Let\'s help you find a perfect match',
                    style: TextStyle(fontSize: 16)),
                const Divider(),
                const PreferenceSection(title: 'Religion', items: [
                  'Islam',
                  'Christian',
                  'Traditional African',
                  'Others'
                ]),
                const PreferenceSection(
                    title: 'Ethnicity/Tribe',
                    items: ['Yoruba', 'Igbo', 'Hausa', 'Others']),
                const PreferenceSection(title: 'Education Level', items: [
                  'Diploma',
                  'Bachelor',
                  'Masters',
                  'PhD/Doctorate',
                  'Others'
                ]),
                const PreferenceSection(title: 'Region', items: [
                  'West',
                  'East',
                  'South-South',
                  'North Central',
                  'North East',
                  'South West'
                ]),
                const PreferenceSection(title: 'Hobbies and Interest', items: [
                  'Racing',
                  'Travelling',
                  'Sports',
                  'Music',
                  'Cooking',
                  'Gaming',
                  'Fashion',
                  'Movies/TV Shows',
                  'Others'
                ]),
                const PreferenceSection(title: 'Age Range', items: [
                  '24-30',
                  '30-35',
                  '36-40',
                  '41-46',
                  '47-55',
                  '56 and above'
                ]),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button press
                    },
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PreferenceSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const PreferenceSection({Key? key, required this.title, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) => PreferenceItem(text: item)).toList(),
        ),
      ],
    );
  }
}

class PreferenceItem extends StatelessWidget {
  final String text;

  const PreferenceItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserPreferencesProvider>(context);
    final isSelected = provider.isSelected(text);

    return GestureDetector(
      onTap: () => provider.toggleItem(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? TextsInsideButtonColor.withOpacity(0.4)
              : Colors.transparent,
          border: Border.all(color: TextsInsideButtonColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text),
      ),
    );
  }
}
