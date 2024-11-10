import 'package:fiander/CONSTANTS/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Event Details model remains the same
class EventDetails {
  final String eventType;
  final String eventDate;
  final String eventTime;

  EventDetails({
    required this.eventType,
    required this.eventDate,
    required this.eventTime,
  });

  factory EventDetails.fromJson(Map<String, dynamic> json) {
    return EventDetails(
      eventType: json['event_type'] ?? '',
      eventDate: json['event_date'] ?? '',
      eventTime: json['event_time'] ?? '',
    );
  }
}

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
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => const LikedEventCard(),
    );
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
}

class LikedEventCard extends StatelessWidget {
  const LikedEventCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Column(
              children: [
                Text('July'),
                Text(
                  '13',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saturday',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text('2:00-3:00pm'),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See event summary'),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}

class EventProvider extends ChangeNotifier {
  // Add any necessary state management logic here
}
