import 'package:fiander/CONSTANTS/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_screen_provider.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

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
            'Contact Us',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('lib/images/fianderlogo.png'),
                        ), // Update the path to your image
                        const SizedBox(height: 16),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Expanded(
                            child: Text(
                              "If you have any questions or suggestions, feel free to reach us. We'd love to hear from you.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                    height: 200), // Space for the half screen container
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100, // TextColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ContactInfo(
                        icon: Icons.laptop,
                        text: "Website: www.FianDer.com",
                      ),
                      SizedBox(height: 16),
                      ContactInfo(
                        icon: Icons.email_outlined,
                        text: "Email: abubarkarisimbambi@gmail.com",
                      ),
                    ],
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

class ContactInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: TextsInsideButtonColor),
        ),
        const SizedBox(width: 16),
        Expanded(
            child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        )),
      ],
    );
  }
}
