import 'package:flutter/material.dart';

// Event Details model remains the same

// First, make sure you have the EventDetails model
class EventDetails {
  final String eventType;
  final String eventDate;
  final String eventTime;
  final bool isLiked;
  EventDetails({
    required this.eventType,
    required this.eventDate,
    required this.eventTime,
    this.isLiked = false, // Default to false
  });

  factory EventDetails.fromJson(Map<String, dynamic> json) {
    return EventDetails(
      eventType: json['event_type'] ?? '',
      eventDate: json['event_date'] ?? '',
      eventTime: json['event_time'] ?? '',
      isLiked: json['is_liked'] ?? false,
    );
  }
}
