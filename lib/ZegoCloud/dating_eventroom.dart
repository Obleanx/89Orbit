import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'dart:async';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class SpeedDatingAudioCallManager {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _currentUserId;
  final String _currentUserGender;

  List<Map<String, dynamic>> _allPairs = [];
  List<String> _spokeTo = [];
  Timer? _roundTimer;
  Timer? _eventCheckTimer;
  final int _roundDurationSeconds = 300; // 5 minutes
  int _notificationCount = 0;

  SpeedDatingAudioCallManager(this._currentUserId, this._currentUserGender);

  Future<void> startSpeedDating(BuildContext context) async {
    try {
      // Fetch all pairs for the current user
      final response = await _supabase
          .from('paired_users2')
          .select('partner_id, gender')
          .eq('user_id', _currentUserId)
          .order('partner_id');

      _allPairs = response;

      if (_allPairs.isEmpty) {
        throw Exception('No paired users found');
      }

      // Start checking for event time
      _startEventCheck(context);
    } catch (e) {
      if (kDebugMode) {
        print('Error starting speed dating: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting speed dating: $e')),
      );
    }
  }

  void _setupZegoCloud(BuildContext context) {
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 1521199983, // Your Zego app ID
      appSign:
          "95796b4ed579f72b017a94a8aa2bac5c10fad6bd56d61d05ac2851a495cafd2d",
      userID: _currentUserId,
      userName: 'User $_currentUserId',
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

  void _startEventCheck(BuildContext context) {
    _eventCheckTimer =
        Timer.periodic(const Duration(minutes: 1), (timer) async {
      final eventDetails = await _getEventDetails();
      if (eventDetails != null) {
        final eventTime = DateTime.parse(eventDetails['event_time']);
        final now = DateTime.now();
        if (now.isAfter(eventTime.subtract(const Duration(minutes: 1))) &&
            now.isBefore(eventTime.add(const Duration(minutes: 5)))) {
          timer.cancel();
          _startNextRound(context);
        } else if (now.isBefore(eventTime)) {
          // Add a notification
          _addNotification();
        }
      }
    });
  }

  Future<Map<String, dynamic>?> _getEventDetails() async {
    final response = await _supabase
        .from('speed_dating_events')
        .select()
        .eq('user_id', _currentUserId)
        .single();
    return response;
  }

  void _addNotification() {
    _notificationCount++;
    // Here you would update your UI to show the notification count
    // For example, you could use a StreamController to notify listeners
  }

  void _startNextRound(BuildContext context) {
    if (_allPairs.isEmpty) {
      // All rounds completed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('you have spoken to your first pair!')),
      );
      return;
    }

    // Finding the next suitable partner
    Map<String, dynamic>? currentPair;
    String? partnerId;
    String? partnerGender;

    for (var pair in _allPairs) {
      partnerId = pair['partner_id'];
      partnerGender = pair['gender'];

      // Check if we haven't spoken to this partner and they are of the opposite gender
      if (!_spokeTo.contains(partnerId) && _isOppositeGender(partnerGender)) {
        currentPair = pair;
        break;
      }
    }

    if (currentPair == null) {
      // No suitable partner found, end the session
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('No more suitable partners available. Session ended.')),
      );
      return;
    }

    // Remove the selected pair from _allPairs
    _allPairs.remove(currentPair);

    _spokeTo.add(partnerId!);

    // Determine if current user should initiate the call
    final shouldInitiate = _currentUserGender.toLowerCase() == 'male';

    if (shouldInitiate) {
      _initiateCall(context, partnerId);
    } else {
      _waitForCall(context, partnerId);
    }

    // Start the timer for this round
    _roundTimer = Timer(Duration(seconds: _roundDurationSeconds), () {
      // End the current call and start the next round
      Navigator.of(context).pop();
      _startNextRound(context);
    });
  }

  bool _isOppositeGender(String? partnerGender) {
    if (_currentUserGender.toLowerCase() == 'male') {
      return partnerGender?.toLowerCase() == 'female';
    } else if (_currentUserGender.toLowerCase() == 'female') {
      return partnerGender?.toLowerCase() == 'male';
    }
    return false; // In case of undefined gender
  }

  void _initiateCall(BuildContext context, String partnerId) {
    ZegoSendCallInvitationButton(
      invitees: [ZegoUIKitUser(id: partnerId, name: 'Partner $partnerId')],
      isVideoCall: false,
      customData: 'FianDer Speed Dating Call',
    );
  }

  void _waitForCall(BuildContext context, String partnerId) {
    // No need to implement anything here.
    // Zego's prebuilt UI will handle incoming calls automatically.
  }
  void endSpeedDating() {
    if (_roundTimer != null) {
      _roundTimer!.cancel();
    }
    if (_eventCheckTimer != null) {
      _eventCheckTimer!.cancel();
    }
    _allPairs = [];
    _spokeTo = [];
    _notificationCount = 0;
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }

  int getNotificationCount() {
    return _notificationCount;
  }
}

// Usage example:
// void startSpeedDatingSession(BuildContext context) {
//   final callManager = SpeedDatingAudioCallManager('current_user_id');
//   callManager.startSpeedDating(context);
// }