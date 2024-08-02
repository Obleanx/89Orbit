import 'package:fiander/CONSTANTS/constants.dart';
import 'package:fiander/PROVIDERS/pay_popup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'userdetails.dart';

class GeneralEventAccessScreen extends StatelessWidget {
  const GeneralEventAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventAccessNotifier = Provider.of<EventAccessNotifier>(context);

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // This allows taps outside the sheet to dismiss it
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.5,
              maxChildSize: 0.8,
              builder: (_, controller) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Access General Event',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Benefits',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildBenefitRow(
                        Icons.check_circle,
                        'Access to a diverse pool of potential matches for N2000',
                      ),
                      _buildBenefitRow(
                        Icons.check_circle,
                        'Opportunities to meet people from various backgrounds',
                      ),
                      _buildBenefitRow(
                        Icons.check_circle,
                        'Simple and straightforward matchmaking process',
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text:
                                  'Upgrade to our tailored Events for a bespoke experience made just for you for ',
                            ),
                            TextSpan(
                              text: 'N5000 only',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: eventAccessNotifier.isUpgradeChecked,
                            focusColor: TextsInsideButtonColor,
                            checkColor: Colors.white,
                            activeColor: TextsInsideButtonColor,
                            hoverColor: TextsInsideButtonColor,
                            onChanged: (value) {
                              eventAccessNotifier.toggleUpgradeChecked(value!);
                            },
                          ),
                          const Text(
                            'Upgrade now for tailored matches',
                            style: TextStyle(
                              color: TextsInsideButtonColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TextsInsideButtonColor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UserPreferencesScreen()),
                          );
                        },
                        child: Text(
                          eventAccessNotifier.isUpgradeChecked
                              ? 'Pay N5,000 now'
                              : 'Pay N2,000 now',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: TextsInsideButtonColor),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
