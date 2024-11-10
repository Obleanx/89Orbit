import 'package:fiander/COMPONENTS/registered_eventsUi.dart';
import 'package:flutter/material.dart';
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
    return ListView.builder(
      itemCount: 5, // Replace with the actual number of liked events
      itemBuilder: (context, index) => const LikedEventCard(),
    );
  }

  Widget _buildRegisteredEvents() {
    return ListView.builder(
      itemCount: 5, // Replace with the actual number of registered events
      itemBuilder: (context, index) => RegisteredEventCard(),
    );
  }

  Widget _buildNoEventsRegistered() {
    return Center(child: Text('No Events Registered'));
  }
}
