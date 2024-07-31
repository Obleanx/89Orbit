import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/join_event.dart';
import 'package:flutter/material.dart';

class PayForEventScreen extends StatefulWidget {
  const PayForEventScreen({super.key});

  @override
  State<PayForEventScreen> createState() => _PayForEventScreenState();
}

class _PayForEventScreenState extends State<PayForEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JoinEventScreen(
                  eventType: 'Your Event Type',
                  selectedDate: '2024-07-31', // Use the correct date format

                  selectedTime: 'Your Selected Time',
                ),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Transform.translate(
                  offset: const Offset(0, -40), // Adjust the offset as needed
                  child: Container(
                    width: double.infinity,
                    height: 345, // Adjust the height as needed
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
