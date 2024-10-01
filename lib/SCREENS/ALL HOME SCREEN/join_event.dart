import 'package:fiander/COMPONENTS/exp_texts.dart';
import 'package:fiander/CONSTANTS/constants.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pay_popup.dart';
import 'tailored_pay_pop.dart';

class JoinEventScreen extends StatefulWidget {
  final String eventType; // Expecting 'Saturday' or 'Sunday'
  final String selectedDate;
  final String selectedTime;

  JoinEventScreen({
    Key? key,
    required this.eventType,
    required this.selectedDate,
    required this.selectedTime,
  }) : super(key: key);

  @override
  State<JoinEventScreen> createState() => _JoinEventScreenState();
}

class _JoinEventScreenState extends State<JoinEventScreen> {
  late final String eventType;
  late final String selectedDate;
  late final String selectedTime;

  @override
  void initState() {
    super.initState();
    eventType = widget.eventType;
    selectedDate = widget.selectedDate;
    selectedTime = widget.selectedTime;
  }

  //this code below allow the pop to check first if the user selected a general or tailored event before showing for making payments.
  void _showEventAccessScreen(BuildContext context, String eventType) {
    if (kDebugMode) {
      print("Event type: $eventType");
    } // Debug print

    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissing by tapping outside
      barrierColor:
          Colors.black.withOpacity(0.6), // Semi-transparent background
      builder: (BuildContext context) {
        if (eventType.trim().toLowerCase() == 'general') {
          if (kDebugMode) {
            print("Showing General Event Screen");
          }
          return const GeneralEventAccessScreen();
        } else if (eventType.trim().toLowerCase() == 'tailored') {
          if (kDebugMode) {
            print("Showing Tailored Event Screen");
          }
          return const TailoredEventAccessScreen();
        } else {
          if (kDebugMode) {
            print("Unknown event type: $eventType");
          }
          // Handle unknown event type
          return AlertDialog(
            title: const Text("Error"),
            content: Text("Unknown event type: $eventType"),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        }
      },
    );
  }

  String getNextWeekendDate(String selectedTimeOption) {
    DateTime currentDate = DateTime.now();
    int daysToAdd;

    if (selectedTimeOption.contains('Saturday')) {
      // Calculate days to next Saturday
      daysToAdd = DateTime.saturday - currentDate.weekday;
      if (daysToAdd <= 0) {
        daysToAdd += 7;
      }
    } else if (selectedTimeOption.contains('Sunday')) {
      // Calculate days to next Sunday
      daysToAdd = DateTime.sunday - currentDate.weekday;
      if (daysToAdd <= 0) {
        daysToAdd += 7;
      }
    } else {
      // Default case, if eventTimeOption is not recognized
      return 'Invalid event time option';
    }

    DateTime nextWeekendDate = currentDate.add(Duration(days: daysToAdd));
    return DateFormat('MMM d').format(nextWeekendDate);
  }

  String formatDateTime(String selectedDate, String selectedTime) {
    try {
      final date = DateTime.parse(selectedDate);
      final formatter = DateFormat('MMM d');
      final formattedDate = formatter.format(date);
      return '$formattedDate, $selectedTime (UTC)';
    } catch (e) {
      if (kDebugMode) {
        print('Error formatting date: $e');
      }
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  // ignore: prefer_const_constructors
                  builder: (context) => HomeScreen1(),
                ));
          },
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('lib/images/event100.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.blueGrey,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.brunch_dining,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'few slots left',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Text.rich(
                    TextSpan(
                      text: 'Event type :',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                      children: [
                        TextSpan(
                          // ignore: unnecessary_string_interpolations
                          text: '  $eventType',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    formatDateTime(selectedDate, selectedTime),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color:
                          TextsInsideButtonColor, // Make sure this color is defined
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'About this event',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 14.0, right: 10),
                  child: ExpandableText(
                    text:
                        "Join us for an exciting evening of virtual speed dating! Meet eligible singles from around the world and discover potential matches from the comfort of your home.\n\nEnjoy engaging conversations, make new connections, and have a fun, memorable experience that could lead to something special.\n\nOur carefully curated event ensures you meet individuals who share your interests and values.You'll get the chance to interact in a safe and friendly environment, guided by our expert hosts algorithm that will make sure the evening runs smoothly.\n\nTo secure your spot, please complete your payment in advance.This small investment guarantees you a place in this exclusive event and helps us ensure the best experience for all participants.\n\nDon't miss out on this opportunity to meet like-minded people and potentially find your perfect match. Sign up now and get ready for an unforgettable evening!",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                  onPressed: () {
                    if (kDebugMode) {
                      print("Button pressed. Current event type: $eventType");
                    }
                    _showEventAccessScreen(context, eventType);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: TextsInsideButtonColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    // minimumSize: const Size(100, 30),
                  ),
                  child: const Text(
                    'Proceed to make payment',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
