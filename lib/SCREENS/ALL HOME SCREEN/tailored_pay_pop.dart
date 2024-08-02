import 'package:fiander/CONSTANTS/constants.dart';
import 'package:flutter/material.dart';

import 'userdetails.dart';

class TailoredEventAccessScreen extends StatelessWidget {
  const TailoredEventAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // This allows taps outside the sheet to dismiss it
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.grey.withOpacity(0.3),
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
                            'Access Tailored Event',
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
                        'Customise your match preference for N5000',
                      ),
                      _buildBenefitRow(
                        Icons.check_circle,
                        'Gain priority access to exclusive events',
                      ),
                      _buildBenefitRow(
                        Icons.check_circle,
                        'Benefit from enhanced match making Algorithm',
                      ),
                      _buildBenefitRow(
                        Icons.check_circle,
                        'Increase your chances of finding your perfect match',
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
                        child: const Text(
                          'Pay N5,000 now',
                          style: TextStyle(
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
