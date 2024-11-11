import 'package:fiander/COMPONENTS/event_details.dart';
import 'package:fiander/CONSTANTS/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fiander/COMPONENTS/registered_eventsUi.dart';

// Widget class
class EventHistoryScreen extends StatefulWidget {
  const EventHistoryScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<EventHistoryScreen> createState() => _EventHistoryScreenState();
}

@override
_EventHistoryScreenState createState() => _EventHistoryScreenState();

class _EventHistoryScreenState extends State<EventHistoryScreen> {
  final bool _isRegistered = true;
  bool _showLiked = false;

// Move the fetch methods to the State class
  Future<String> _fetchUserName() async {
    try {
      final response = await Supabase.instance.client
          .from('verified_users_details')
          .select('name')
          .eq('user_id', widget.userId)
          .single();

      return response['name'] as String;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user name: $e');
      }
      return 'N/A';
    }
  }

  Future<EventDetails> _fetchEventDetails() async {
    try {
      final response = await Supabase.instance.client
          .from('speed_dating_events')
          .select('event_type, event_date, event_time')
          .single();

      return EventDetails.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching event details: $e');
      }
      return EventDetails(
        eventType: 'N/A',
        eventDate: 'N/A',
        eventTime: 'N/A',
      );
    }
  }

  late Future<List<EventDetails>> likedEventsFuture;

  @override
  void initState() {
    super.initState();
    likedEventsFuture = _fetchLikedEvents();
  }

  Future<List<EventDetails>> _fetchLikedEvents() async {
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        return [];
      }

      final response = await Supabase.instance.client
          .from('speed_dating_events')
          .select('event_type, event_date, event_time, is_liked')
          .eq('user_id', currentUser.id)
          .eq('is_liked', true) // Only fetch liked events
          .order('event_date', ascending: true);

      if (response == null || (response as List).isEmpty) {
        return [];
      }

      return (response as List)
          .map((event) => EventDetails.fromJson(event))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching liked events: $e');
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Events',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          ),
        ),
        body: Column(
          children: [
            Center(child: _buildToggleButtons()),
            Expanded(
              child: _isRegistered
                  ? (_showLiked
                      ? _buildLikedEvents()
                      : _buildRegisteredEvents())
                  : _buildNoEventsRegistered(),
            ),
          ],
        ),
        bottomNavigationBar: _isRegistered && !_showLiked
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: elevatedButtonDesign,
                  child: const Text(
                    'Add to Calendar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => setState(() {
                _showLiked = false;
              }),
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () => setState(() {
                _showLiked = true;
              }),
              child: const Text('Liked'),
            ),
          ],
        ),
        AnimatedAlign(
          alignment: _showLiked ? Alignment.centerRight : Alignment.centerLeft,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 2,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisteredEvents() {
    return FutureBuilder(
      future: Future.wait([_fetchUserName(), _fetchEventDetails()]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available.'));
        }

        // Unpack data
        final userName = snapshot.data![0] as String;
        final eventDetails = snapshot.data![1] as EventDetails;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'Event Summary',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('lib/emojis/emoji3.png'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    'The speed date event organizer will send you instructions for joining before the event',
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(),
                _buildInfoRow('Name', userName),
                _buildInfoRow('Event Type', eventDetails.eventType),
                _buildInfoRow('Date', eventDetails.eventDate),
                _buildInfoRow('Time', eventDetails.eventTime),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLikedEvents() {
    return FutureBuilder<List<EventDetails>>(
      future: likedEventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final events = snapshot.data ?? [];

        if (events.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No Liked Events',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length,
          itemBuilder: (context, index) {
            return LikedEventCard(eventDetails: events[index]);
          },
        );
      },
    );
  }
}

Widget _buildNoEventsRegistered() {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //  Image.network('https://example.com/sad_vector.png'),
        Text('No Events Registered'),
      ],
    ),
  );
}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}

class EventProvider extends ChangeNotifier {
  // Add any necessary state management logic here
}
