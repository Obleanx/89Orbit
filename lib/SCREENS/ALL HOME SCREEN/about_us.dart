import 'package:fiander/COMPONENTS/exp_texts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_screen_provider.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsProvider>(
      create: (_) => SettingsProvider(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'About Us',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpandableText(
                  text:
                      "At FianDer, we believe everyone deserves a chance at love and we are dedicated to providing a platform where you can meet potential matches in a fun and efficient manner.",
                ),
                SizedBox(height: 16),
                Text(
                  "With our innovative approach to speed dating, you can enjoy the ease of meeting new people from the comfort of your own space.",
                ),
                SizedBox(height: 16),
                Text(
                  "Our team is committed to creating a safe and inclusive environment where singles can explore romantic possibilities and forge genuine connections.",
                ),
                SizedBox(height: 16),
                Text(
                  "Whether you are looking for your soulmate or hoping to expand your social circle, FianDer is here to support you every step of the way.",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
