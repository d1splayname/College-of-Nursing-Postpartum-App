import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_service.dart';

class CalendarEvent {
  final int? id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String eventType;
  final String? postpartumStage;
  final String source;

  const CalendarEvent({
    this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.eventType,
    this.postpartumStage,
    required this.source,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'] as int?,
      title: json['title'] as String? ?? 'Untitled event',
      description: json['description'] as String? ?? '',
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      eventType: json['event_type'] as String? ?? 'personal',
      postpartumStage: json['postpartum_stage'] as String?,
      source: json['source'] as String? ?? 'personal',
    );
  }
}

class CalendarService {
  static const _apiBaseUrl = 'http://localhost:8080';
  final AuthService _authService;

  CalendarService({AuthService? authService})
    : _authService = authService ?? AuthService();

  Future<List<CalendarEvent>> fetchEvents() async {
    final response = await http.get(
      Uri.parse('$_apiBaseUrl/api/calendar/events'),
      headers: await _authService.authenticatedHeaders(),
    );
    if (response.statusCode != 200) {
      throw ApiException(
        response.body.isNotEmpty
            ? response.body
            : 'Could not load calendar events.',
      );
    }
    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((event) => CalendarEvent.fromJson(event as Map<String, dynamic>))
        .toList();
  }

  Future<CalendarEvent> createEvent({
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final response = await http.post(
      Uri.parse('$_apiBaseUrl/api/calendar/events'),
      headers: await _authService.authenticatedHeaders(),
      body: jsonEncode({
        'title': title,
        'description': description,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'event_type': 'personal',
      }),
    );
    if (response.statusCode != 201) {
      throw ApiException(
        response.body.isNotEmpty
            ? response.body
            : 'Could not create calendar event.',
      );
    }
    return CalendarEvent.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<void> deleteEvent(int eventId) async {
    final response = await http.delete(
      Uri.parse('$_apiBaseUrl/api/calendar/events/$eventId'),
      headers: await _authService.authenticatedHeaders(),
    );
    if (response.statusCode != 204) {
      throw ApiException(
        response.body.isNotEmpty
            ? response.body
            : 'Could not delete calendar event.',
      );
    }
  }

  List<CalendarEvent> localMilestones(DateTime postpartumStart) {
    const milestones = <({int week, String stage})>[
      (week: 0, stage: 'Early Recovery'),
      (week: 2, stage: 'Building Strength'),
      (week: 4, stage: 'Gaining Confidence'),
      (week: 8, stage: 'Thriving Mama'),
    ];

    return milestones.map((milestone) {
      final date = DateTime(
        postpartumStart.year,
        postpartumStart.month,
        postpartumStart.day,
      ).add(Duration(days: milestone.week * 7));
      return CalendarEvent(
        title: milestone.week == 0
            ? 'Postpartum begins'
            : 'Postpartum week ${milestone.week}',
        description: 'Entering the ${milestone.stage} stage.',
        startTime: date,
        endTime: date.add(const Duration(days: 1)),
        eventType: 'postpartum_milestone',
        postpartumStage: milestone.stage,
        source: 'generated',
      );
    }).toList();
  }
}
