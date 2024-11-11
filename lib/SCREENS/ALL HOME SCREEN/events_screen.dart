import 'package:fiander/COMPONENTS/event_details.dart';
import 'package:fiander/COMPONENTS/registered_eventsUi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart'; // Adjust based on actual file structure
import 'nav_bar.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final bool _isRegistered = true;
  bool _showLiked = false;
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen1()),
            );
          },
        ),
        title: const Text('Events'),
      ),
      body: Column(
        children: [
          Center(child: _buildToggleButtons()),
          Expanded(
            child: _isRegistered
                ? (_showLiked ? _buildLikedEvents() : _buildRegisteredEvents())
                : _buildNoEventsRegistered(),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
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

Widget _buildRegisteredEvents() {
  return ListView.builder(
    itemCount: 5, // Replace with the actual number of registered events
    itemBuilder: (context, index) => RegisteredEventCard(
      userId: Supabase.instance.client.auth.currentUser?.id ?? '',
    ),
  );
}

Widget _buildNoEventsRegistered() {
  return const Center(child: Text('No Events Registered'));
}
