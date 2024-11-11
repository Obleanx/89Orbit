import 'package:fiander/COMPONENTS/event_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

import '../CONSTANTS/constants.dart'; // Add this for date formatting

class RegisteredEventCard extends StatefulWidget {
  const RegisteredEventCard({
    super.key,
    required this.userId, // Add userId parameter
  });

  final String userId; // Add this to get the current user's ID

  @override
  State<RegisteredEventCard> createState() => _RegisteredEventCardState();
}

class _RegisteredEventCardState extends State<RegisteredEventCard> {
  late Future<List<EventDetails>> eventsFuture;

  @override
  void initState() {
    super.initState();
    eventsFuture = _fetchEventDetails();
  }

  Future<List<EventDetails>> _fetchEventDetails() async {
    try {
      final response = await Supabase.instance.client
          .from('speed_dating_events')
          .select('event_type, event_date, event_time')
          .eq('user_id', widget.userId) // Add filter for current user
          .order('event_date', ascending: true); // Order by date

      if (response == null || (response as List).isEmpty) {
        return [];
      }

      return (response as List)
          .map((event) => EventDetails.fromJson(event))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching event details: $e');
      }
      return [];
    }
  }

  Widget _buildNoEventsRegistered() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'No Events Registered',
            style: TextStyle(
              fontSize: 18,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(EventDetails event) {
    // Parse the date string
    final DateTime eventDate = DateTime.parse(event.eventDate);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  DateFormat('MMM').format(eventDate), // Month abbreviation
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  DateFormat('d').format(eventDate), // Day of month
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE').format(eventDate), // Day name
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(event.eventTime),
                  TextButton(
                    onPressed: () {
                      // Add your event summary navigation logic here
                    },
                    child: const Text(
                      'See event summary',
                      style: TextStyle(
                        color: TextsInsideButtonColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventDetails>>(
      future: eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final events = snapshot.data ?? [];

        if (events.isEmpty) {
          return _buildNoEventsRegistered();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length,
          itemBuilder: (context, index) => _buildEventCard(events[index]),
        );
      },
    );
  }
}

// Modify the LikedEventCard to accept event details
class LikedEventCard extends StatelessWidget {
  const LikedEventCard({
    super.key,
    required this.eventDetails,
  });

  final EventDetails eventDetails;

  @override
  Widget build(BuildContext context) {
    final DateTime eventDate = DateTime.parse(eventDetails.eventDate);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  DateFormat('MMM').format(eventDate),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  DateFormat('d').format(eventDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE').format(eventDate),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(eventDetails.eventTime),
                  TextButton(
                    onPressed: () {
                      // Add your event summary navigation logic here
                    },
                    child: const Text(
                      'See event summary',
                      style: TextStyle(
                        color: TextsInsideButtonColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
