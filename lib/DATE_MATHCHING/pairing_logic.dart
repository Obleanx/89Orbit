import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

Future<void> pairUsers(BuildContext context) async {
  final supabase = Supabase.instance.client;
  final uuid = Uuid();

  try {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // Fetch users from speed_dating_events
    final response = await supabase
        .from('speed_dating_events')
        .select('user_id, event_type, event_time, event_date, gender')
        .order('created_at');

    final List<Map<String, dynamic>> users = response;

    if (users.isEmpty) {
      throw Exception('No users found in speed_dating_events');
    }

    print('Fetched users: $users'); // Debug print

    // Separate male and female users (case-insensitive)
    final maleUsers = users
        .where((user) => user['gender'].toString().toLowerCase() == 'male')
        .toList();
    final femaleUsers = users
        .where((user) => user['gender'].toString().toLowerCase() == 'female')
        .toList();

    print(
        'Male users: ${maleUsers.length}, Female users: ${femaleUsers.length}'); // Debug print

    // Create pairs
    final pairs = <Map<String, dynamic>>[];
    final int pairCount = maleUsers.length < femaleUsers.length
        ? maleUsers.length
        : femaleUsers.length;

    for (int i = 0; i < pairCount; i++) {
      final maleUser = maleUsers[i];
      final femaleUser = femaleUsers[i];
      final pairId = uuid.v4();

      // Check if event time and date match
      if (maleUser['event_time'] == femaleUser['event_time'] &&
          maleUser['event_date'] == femaleUser['event_date']) {
        // Add male user to pairs
        pairs.add({
          'event_id': uuid.v4(),
          'user_id': maleUser['user_id'],
          'partner_id': femaleUser['user_id'],
          'pair_id': pairId,
          'event_type': maleUser['event_type'],
          'event_time': maleUser['event_time'],
          'event_date': maleUser['event_date'],
          'gender': maleUser['gender'],
          'pair_status': 'paired',
        });

        // Add female user to pairs
        pairs.add({
          'event_id': uuid.v4(),
          'user_id': femaleUser['user_id'],
          'partner_id': maleUser['user_id'],
          'pair_id': pairId,
          'event_type': femaleUser['event_type'],
          'event_time': femaleUser['event_time'],
          'event_date': femaleUser['event_date'],
          'gender': femaleUser['gender'],
          'pair_status': 'paired',
        });
      }
    }

    if (pairs.isEmpty) {
      throw Exception(
          'No pairs could be created. There might be no matching male-female pairs or event times/dates. Male users: ${maleUsers.length}, Female users: ${femaleUsers.length}');
    }

    // Insert paired users into paired_users2 table
    final insertResponse = await supabase.from('paired_users2').insert(pairs);

    // Close loading indicator
    Navigator.of(context, rootNavigator: true).pop();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Successfully paired ${pairs.length ~/ 2} users')),
    );
  } catch (e) {
    // Close loading indicator
    Navigator.of(context, rootNavigator: true).pop();

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error pairing users: $e')),
    );
    print('Error pairing users: $e');
  }
}
