import 'package:fiander/COMPONENTS/exp_texts.dart';
import 'package:fiander/PROVIDERS/settings_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({super.key});

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
            'How to Use',
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
                SizedBox(height: 16),
                ExpandableText(
                  text:
                      "1• sign Up: create your FianDer account by providing some basic information about yourself. Don't worry it's quick and easy",
                ),
                SizedBox(height: 16),
                ExpandableText(
                  text:
                      "2• Explore Events: Browse through our upcoming speed dating events and choose the ones that interest you. Whether you prefer general events or tailored matchmaking, there is something for everyone.",
                ),
                SizedBox(height: 16),
                ExpandableText(
                  text:
                      "3• Register: Once you have found an event that suits your prefernce, simply register and secure your spot. Payment is required to confirm your participation.",
                ),
                SizedBox(height: 16),
                ExpandableText(
                  text:
                      "4• Attend the event: On the day of the event, login to FianDer and get ready to meet potential matches. Follow the prompts and guildelines provided to navigate through the speed dating rounds.",
                ),
                SizedBox(height: 16),
                ExpandableText(
                    text:
                        "5• Connect: Engage in short, meaningful conversations with your matches during the speed dating rounds. Make note of any potential connections and mutual interest."),
                SizedBox(height: 16),
                ExpandableText(
                    text:
                        "6• FollowUp: After the event, you will receive feedback and matches suggestion based on your interactions.Take the initiative to follow up with your matches and continue building connections."),
                SizedBox(height: 16),
                ExpandableText(
                    text:
                        "7• Enjoy the Experience: Have fun be yourself and stay open to new possibilities. Whethere you find your potential match or simplymake new friends, every FianDer experience is a step towards a meaniful connection."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
