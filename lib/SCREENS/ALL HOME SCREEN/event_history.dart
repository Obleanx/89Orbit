import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventHistoryScreen extends StatefulWidget {
  @override
  _EventHistoryScreenState createState() => _EventHistoryScreenState();
}

class _EventHistoryScreenState extends State<EventHistoryScreen> {
  bool _isRegistered = true;
  bool _showLiked = false;

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
          title: const Text('Event'),
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
                  child: const Text('Add to Calendar'),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Column(
      children: [
        Row(
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
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          const Text(
            'Event Summary',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage('lib/emojis/emoji3.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'The speed date event organizer will send you instructions for joining before the event',
            ),
          ),
          const Divider(),
          _buildInfoRow('Name', 'Amina Gabriel'),
          _buildInfoRow('Event Type', 'General Event'),
          _buildInfoRow('Date', 'July 13, 2024'),
          _buildInfoRow('Time', '2:00-3:00pm'),
          const SizedBox(height: 16),
          ...List.generate(5, (index) => EventDetailsCard()),
        ],
      ),
    );
  }

  Widget _buildLikedEvents() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => LikedEventCard(),
    );
  }

  Widget _buildNoEventsRegistered() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network('https://example.com/sad_vector.png'),
          const Text('No Events Registered'),
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;

  ExpandableText(this.text);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.text,
          maxLines: _expanded ? null : 2,
          overflow: _expanded ? null : TextOverflow.ellipsis,
        ),
        TextButton(
          onPressed: () => setState(() => _expanded = !_expanded),
          child: Text(_expanded ? 'Show Less' : 'Show More'),
        ),
      ],
    );
  }
}

class EventDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
              ElevatedButton(
                onPressed: () {},
                child: const Text('Registered'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LikedEventCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
