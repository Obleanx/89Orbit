import 'package:fiander/COMPONENTS/upcoming_events.dart';
import 'package:flutter/material.dart';

class SaturdayEventDateText extends StatelessWidget {
  final String eventTime;

  const SaturdayEventDateText({Key? key, required this.eventTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5),
      child: Text(
        '${getNextWeekendDate(true)},  $eventTime',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class SundayEventDateText extends StatelessWidget {
  final String eventTime;

  const SundayEventDateText({Key? key, required this.eventTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5),
      child: Text(
        '${getNextWeekendDate(false)},  $eventTime',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
