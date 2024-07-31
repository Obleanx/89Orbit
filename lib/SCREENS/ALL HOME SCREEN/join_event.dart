import 'package:fiander/COMPONENTS/exp_texts.dart';
import 'package:fiander/CONSTANTS/constants.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/home_screen.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/payment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../COMPONENTS/upcoming_events.dart';

class JoinEventScreen extends StatefulWidget {
  final String eventType; // Expecting 'Saturday' or 'Sunday'
  final String selectedDate;
  final String selectedTime;

  const JoinEventScreen({
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
            Container(
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
                  child: Text(
                    'Event Type: $eventType',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Make sure this color is defined
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
                  padding: EdgeInsets.only(left: 14.0),
                  child: ExpandableText(
                    text:
                        "Join us for an exciting evening of virtual speed dating! Meet eligible singles from around the world and discover potential matches from the comfort of your home.",
                  ),
                ),
                UpcomingEventsTitle(),
                //  SaturdayEventCard(time: '2:00-3:00pm'),
                const WeekendEventList(
                  saturdayTime: '2:00-3:00pm',
                  sundayTime: '4:00-5:00pm',
                ),
                const SizedBox(height: 10),
                // SundayEventCard(time: '4:00-5:00pm'),
                const SizedBox(height: 10),
                const SaturdayEventCard(time: '4:00-5:00pm'),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          // ignore: prefer_const_constructors
                          builder: (context) => PayForEventScreen(),
                        ));
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
