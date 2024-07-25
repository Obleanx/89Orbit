import 'package:fiander/COMPONENTS/setting_listitems.dart';
import 'package:fiander/PROVIDERS/settings_screen_provider.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/about_us.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/faq.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/how_to_use.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/refund_policy.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/support.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'nav_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          title: const Text('Settings'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationOption(
                title: 'Push Notifications',
                valueProvider: (provider) => provider.pushNotificationsEnabled,
                onChanged: (provider, value) {
                  provider.setPushNotifications(value);
                },
              ),
              NotificationOption(
                title: 'Email Notifications',
                valueProvider: (provider) => provider.emailNotificationsEnabled,
                onChanged: (provider, value) {
                  provider.setEmailNotifications(value);
                },
              ),
              const SizedBox(height: 16),
              const Divider(
                thickness: 2,
                height: 2,
              ),
              const SizedBox(height: 16),
              SettingsListItem(
                title: 'About Us',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // ignore: prefer_const_constructors
                      builder: (context) => AboutUsScreen(),
                    ),
                  );
                },
              ),
              SettingsListItem(
                title: 'Refund Policy',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // ignore: prefer_const_constructors
                      builder: (context) => RefundPolicyScreen(),
                    ),
                  );
                },
              ),
              SettingsListItem(
                title: 'How to Use',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // ignore: prefer_const_constructors
                      builder: (context) => HowToUseScreen(),
                    ),
                  );
                },
              ),
              SettingsListItem(
                title: 'FAQ',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        // ignore: prefer_const_constructors
                        builder: (context) => FAQScreen(),
                      ));
                },
              ),
              SettingsListItem(
                title: 'Blog',
                onTap: () {
                  // Handle Blog tap
                },
              ),
              SettingsListItem(
                title: 'Support',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        // ignore: prefer_const_constructors
                        builder: (context) => ContactUsScreen(),
                      ));
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}

//for the iOs switch toogle button
class NotificationOption extends StatelessWidget {
  final String title;
  final bool Function(SettingsProvider) valueProvider;
  final Function(SettingsProvider, bool) onChanged;

  const NotificationOption({
    required this.title,
    required this.valueProvider,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, provider, child) {
        bool value = valueProvider(provider);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              CupertinoSwitch(
                value: value,
                onChanged: (newValue) {
                  onChanged(provider, newValue);
                },
                activeColor: CupertinoColors.activeBlue,
              ),
            ],
          ),
        );
      },
    );
  }
}
