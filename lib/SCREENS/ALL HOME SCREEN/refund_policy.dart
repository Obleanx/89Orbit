import 'package:fiander/COMPONENTS/exp_texts.dart';
import 'package:fiander/CONSTANTS/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_screen_provider.dart';

class RefundPolicyScreen extends StatelessWidget {
  const RefundPolicyScreen({super.key});

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
            'Policy',
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
                  'Refund Policy',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                ExpandableText(
                  text:
                      "If you find a match at your tailored event, you are eligible for a 50% discount from us on your next registration for a tailored event.",
                ),
                SizedBox(height: 16),
                ExpandableText(
                  text:
                      "• This offer is exclusive for users who have participated in the tailored event and meet the eligibility criteria.",
                ),
                SizedBox(height: 16),
                ExpandableText(
                  text:
                      "• This discount is valid for one-time use only and must be redeemed within six months from the date of your previous event.",
                ),
                SizedBox(height: 16),
                ExpandableText(
                  text:
                      "• The discount applies only for registration fees of tailored events and cannot be used for general events or other services offered by FianDer.",
                ),
                SizedBox(height: 16),
                Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: TextsInsideButtonColor,
                  ),
                ),
                SizedBox(height: 16),
                ExpandableText(
                  text:
                      "Your privacy is our priority. We are committed to safeguarding your information and ensuring its confidentiality.",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
