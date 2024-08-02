import 'package:fiander/COMPONENTS/join_button.dart';
import 'package:fiander/CONSTANTS/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpcomingEventCard extends StatelessWidget {
  final String date;
  final String time;

  const UpcomingEventCard({Key? key, required this.date, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xff9e9e9e),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.event,
                    color: TextsInsideButtonColor, size: 24),
                const SizedBox(width: 8),
                Expanded(child: Text(date)),
                const SizedBox(width: 5),
                const Icon(Icons.access_time_outlined,
                    color: TextsInsideButtonColor, size: 24),
                const SizedBox(width: 6),
                Text(time),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventSelectionDialog(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  elevation: 8.0,
                  backgroundColor: TextsInsideButtonColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: const Size(100, 30),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SaturdayEventCard extends StatelessWidget {
  final String time;

  const SaturdayEventCard({Key? key, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = getNextWeekendDate(true); // Get upcoming Saturday
    return UpcomingEventCard(date: date, time: time);
  }
}

class SundayEventCard extends StatelessWidget {
  final String time;

  const SundayEventCard({Key? key, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = getNextWeekendDate(false); // Get upcoming Sunday
    return UpcomingEventCard(date: date, time: time);
  }
}

//this method i used it to calculate the date of the upcoming event for just one week only.
String getNextWeekendDate(bool isSaturday) {
  final today = DateTime.now();
  final nextWeekend =
      today.add(Duration(days: (isSaturday ? 6 : 7) - today.weekday));
  final day = DateFormat('EEEE').format(nextWeekend); // Day of the week
  final month = DateFormat('MMMM').format(nextWeekend); // Month name
  final dayNum = DateFormat('d').format(nextWeekend); // Day of the month
  final suffix = getDaySuffix(
      nextWeekend.day); // Day suffix (e.g., "st", "nd", "rd", "th")

  return "$day, $month $dayNum$suffix";
}

//this method calculates the weekends for the whole month and get emty when there is no weekend left in the month.

List<String> getAllUpcomingWeekendDates() {
  final today = DateTime.now();
  final currentMonth = today.month;
  final weekends = <String>[];

  DateTime date = DateTime(today.year, currentMonth, today.day);

  while (date.month == currentMonth) {
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      final day = DateFormat('EEEE').format(date); // Day of the week
      final month = DateFormat('MMMM').format(date); // Month name
      final dayNum = DateFormat('d').format(date); // Day of the month
      final suffix =
          getDaySuffix(date.day); // Day suffix (e.g., "st", "nd", "rd", "th")
      weekends.add("$day, $month $dayNum$suffix");
    }
    date = date.add(Duration(days: 1));
  }
  return weekends;
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

class WeekendEventList extends StatelessWidget {
  final String saturdayTime;
  final String sundayTime;

  const WeekendEventList(
      {Key? key, required this.saturdayTime, required this.sundayTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weekends = getAllUpcomingWeekendDates();

    return Column(
      children: weekends.map((date) {
        final isSaturday = date.startsWith('Saturday');
        return Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 6),
          child: UpcomingEventCard(
            date: date,
            time: isSaturday ? saturdayTime : sundayTime,
          ),
        );
      }).toList(),
    );
  }
}
