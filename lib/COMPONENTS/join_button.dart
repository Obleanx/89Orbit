import 'package:fiander/CONSTANTS/constants.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/join_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JoinButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showEventSelectionDialog(context);
      },
      style: ElevatedButton.styleFrom(
        elevation: 10.0,
        backgroundColor: TextsInsideButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        minimumSize: const Size(100, 30),
      ),
      child: const Text(
        'Join Event',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showEventSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.grey
          .withOpacity(0.6), // Blur effect for the second pop message
      builder: (BuildContext context) {
        return EventSelectionDialog();
      },
    );
  }
}

class EventSelectionDialog extends StatefulWidget {
  @override
  _EventSelectionDialogState createState() => _EventSelectionDialogState();
}

class _EventSelectionDialogState extends State<EventSelectionDialog> {
  String? selectedEvent;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          'Choose Event',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildEventOption('General'),
          const SizedBox(height: 16),
          _buildEventOption('Tailored'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (selectedEvent != null) {
              Navigator.of(context).pop();
              _showTimeSelectionDialog(context, selectedEvent!);
            }
          },
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildEventOption(String eventType) {
    bool isSelected = selectedEvent == eventType;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEvent = eventType;
        });
      },
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? TextsInsideButtonColor : Colors.grey,
                width: 3,
              ),
            ),
            child: isSelected
                ? Container(
                    margin: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(eventType),
        ],
      ),
    );
  }

  void _showTimeSelectionDialog(BuildContext context, String eventType) {
    showDialog(
      context: context,
      barrierColor: Colors.grey
          .withOpacity(0.6), //blur effect for the second pop message.
      builder: (BuildContext context) {
        return TimeSelectionDialog(eventType: eventType);
      },
    );
  }
}

class TimeSelectionDialog extends StatefulWidget {
  final String eventType;

  TimeSelectionDialog({required this.eventType});

  @override
  _TimeSelectionDialogState createState() => _TimeSelectionDialogState();
}

class _TimeSelectionDialogState extends State<TimeSelectionDialog> {
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          'Select Time',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimeOption('Saturday, 2:00-3:00pm'),
          const SizedBox(height: 16),
          _buildTimeOption('Sunday, 4:00-5:00pm'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (selectedTime != null) {
              Navigator.of(context).pop();
              _navigateToJoinEventScreen(
                  context, widget.eventType, selectedTime!);
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  Widget _buildTimeOption(String time) {
    bool isSelected = selectedTime == time;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = time;
        });
      },
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? TextsInsideButtonColor : Colors.grey,
                width: 3,
              ),
            ),
            child: isSelected
                ? Container(
                    margin: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(time),
        ],
      ),
    );
  }

  void _navigateToJoinEventScreen(
      BuildContext context, String eventType, String selectedTime) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JoinEventScreen(
          eventType: eventType,
          selectedDate:
              getNextWeekendDate(eventType), // Use the correct date format
          selectedTime: selectedTime,
        ),
      ),
    );
  }

  String getNextWeekendDate(String eventType) {
    DateTime currentDate = DateTime.now();
    int daysToAdd;
    if (eventType == 'General' || eventType == 'Tailored') {
      // Set to next Saturday
      daysToAdd = DateTime.saturday - currentDate.weekday;
      if (daysToAdd <= 0) {
        daysToAdd += 7;
      }
    } else {
      // Set to next Sunday
      daysToAdd = DateTime.sunday - currentDate.weekday;
      if (daysToAdd <= 0) {
        daysToAdd += 7;
      }
    }
    DateTime nextWeekendDate = currentDate.add(Duration(days: daysToAdd));
    return DateFormat('yyyy-MM-dd').format(nextWeekendDate);
  }
}
