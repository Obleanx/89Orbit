// ignore_for_file: library_private_types_in_public_api

import 'package:fiander/CONSTANTS/constants.dart';
import 'package:flutter/material.dart';

class EventAccessScreen extends StatefulWidget {
  const EventAccessScreen({super.key});

  @override
  _EventAccessScreenState createState() => _EventAccessScreenState();
}

class _EventAccessScreenState extends State<EventAccessScreen> {
  bool _isUpgradeChecked = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: DraggableScrollableSheet(
          //  initialChildSize: 0.5,
          minChildSize: 0.5,
          maxChildSize: 0.8,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: TextColor,
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
                        icon: const Icon(
                          Icons.cancel,
                        ),
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
                        color: Colors.black),
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
                                'Upgrade to our tailored Events for a bespoke experience made just for you for '),
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
                        value: _isUpgradeChecked,
                        focusColor: TextsInsideButtonColor,
                        checkColor: Colors.white,
                        activeColor: TextsInsideButtonColor,
                        hoverColor: TextsInsideButtonColor,
                        onChanged: (value) {
                          setState(() {
                            _isUpgradeChecked = value!;
                          });
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
                    child: Text(
                      _isUpgradeChecked ? 'Pay N5,000 now' : 'Pay N2,000 now',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TextsInsideButtonColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      // Handle payment logic here
                    },
                  ),
                ],
              ),
            );
          },
        ),
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
