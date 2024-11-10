import 'package:flutter/material.dart';

class RegisteredEventCard extends StatefulWidget {
  const RegisteredEventCard({super.key});

  @override
  State<RegisteredEventCard> createState() => _RegisteredEventCardState();
}

class _RegisteredEventCardState extends State<RegisteredEventCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5)),
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
          ],
        ),
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
          borderRadius: BorderRadius.circular(5)),
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
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
