import 'package:fiander/COMPONENTS/exp_texts.dart';
import 'package:fiander/CONSTANTS/constants.dart';
import 'package:fiander/PROVIDERS/settings_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// title: 'FAQ',

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

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
            'FAQ',
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
                Text(
                  '1• What is FianDer?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TextsInsideButtonColor, //Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                ExpandableText(
                  text:
                      "FianDer is a mobile app that offers virtual speed dating events, providing singles with the oppurtunity to meet potential matches from the comfort of their own space.",
                ),
                SizedBox(height: 16),
                Text(
                  "2• How does FianDer works?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TextsInsideButtonColor, //Colors.black,,
                  ),
                ),
                SizedBox(height: 16),
                ExpandableText(
                  text:
                      " FianDer hosts speed dating events where participants engage in short, timed conversations with potentail matches. Users register for events, participates in multiple rounds of speed dates, and have the chance to mutually match with others.",
                ),
                SizedBox(height: 16),
                Text(
                  "3• Are the events tailored to specific preferences?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TextsInsideButtonColor, //Colors.black,,
                  ),
                ),
                SizedBox(height: 16),
                ExpandableText(
                  text:
                      "Yes, FinaDer offers both general and tailored events. General events match participants randomly, while tailored events allow users to select specific criteria such as age, range, location, matchmaking experience.",
                ),
                SizedBox(height: 16),
                Text(
                  "4• How do I sign up for an event?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TextsInsideButtonColor, //Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                ExpandableText(
                  text:
                      "Simply create an account on FianDer, browse through upcoming events and register for the ones that interest you. Payments are required to confirm your participation",
                ),
                SizedBox(height: 16),
                Text(
                  "5• What Happens during a speed dating event",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TextsInsideButtonColor, //Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                ExpandableText(
                  text:
                      "Each event consists of multiple rounds of short timed conversations between participants. After each round, users indicate if they would like to proceed to the next stage with their match.",
                ),
                SizedBox(height: 16),
                Text(
                  "6• How do I know If someone is interested in me?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TextsInsideButtonColor, //Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                ExpandableText(
                  text:
                      "If both you and your match mutually indicate interest in each other, you will be notified of the match. You can then proceed to exchange contact information and continue getting to know each other outside of the app.",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
