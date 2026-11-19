import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'calendar_service.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const _channelId = 'calendar_reminders';
  static const _channelName = 'Calendar reminders';
  static const _channelDescription =
      'Reminders for appointments and postpartum milestones.';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final Set<int> _scheduledIds = <int>{};
  final Set<int> _webShownIds = <int>{};
  Timer? _webTimer;
  List<CalendarEvent> _webEvents = <CalendarEvent>[];
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    if (!kIsWeb) {
      tz.initializeTimeZones();
      final timezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezone.identifier));
    }

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('ic_launcher'),
      iOS: DarwinInitializationSettings(),
      web: WebInitializationSettings(),
    );

    await _plugin.initialize(settings: initializationSettings);
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    await initialize();

    if (kIsWeb) {
      final webPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            WebFlutterLocalNotificationsPlugin
          >();
      return await webPlugin?.requestNotificationsPermission() ?? false;
    }

    final androidGranted = await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    final iosGranted = await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    return androidGranted ?? iosGranted ?? false;
  }

  Future<void> syncEvents(Iterable<CalendarEvent> events) async {
    await initialize();
    final eventList = events.toList(growable: false);

    if (kIsWeb) {
      _webEvents = eventList;
      final currentIds = eventList.map(_notificationId).toSet();
      _webShownIds.removeWhere((id) => !currentIds.contains(id));
      _startWebTimer();
      return;
    }

    for (final id in _scheduledIds) {
      await _plugin.cancel(id: id);
    }
    _scheduledIds.clear();

    final upcoming = eventList
        .where((event) => event.startTime.isAfter(DateTime.now()))
        .take(64);
    for (final event in upcoming) {
      await _scheduleMobileEvent(event);
    }
  }

  Future<void> cancelEvent(CalendarEvent event) async {
    await initialize();
    final id = _notificationId(event);
    await _plugin.cancel(id: id);
    _scheduledIds.remove(id);
    _webEvents = _webEvents.where((item) => item.id != event.id).toList();
  }

  void _startWebTimer() {
    _webTimer?.cancel();
    _webTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _showDueWebEvents(),
    );
    unawaited(_showDueWebEvents());
  }

  Future<void> _showDueWebEvents() async {
    if (_webEvents.isEmpty) return;
    final now = DateTime.now();
    final dueEvents = _webEvents.where(
      (event) =>
          !event.startTime.isAfter(now) &&
          event.startTime.isAfter(now.subtract(const Duration(minutes: 1))),
    );
    for (final event in dueEvents) {
      final id = _notificationId(event);
      if (_webShownIds.contains(id)) continue;
      await _show(event);
      _webShownIds.add(id);
    }
  }

  Future<void> _scheduleMobileEvent(CalendarEvent event) async {
    final scheduledDate = tz.TZDateTime.from(event.startTime, tz.local);
    await _plugin.zonedSchedule(
      id: _notificationId(event),
      title: event.title,
      body: event.description.isEmpty
          ? 'You have a calendar event today.'
          : event.description,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: event.id?.toString(),
    );
    _scheduledIds.add(_notificationId(event));
  }

  Future<void> _show(CalendarEvent event) {
    return _plugin.show(
      id: _notificationId(event),
      title: event.title,
      body: event.description.isEmpty
          ? 'You have a calendar event now.'
          : event.description,
      notificationDetails: const NotificationDetails(
        web: WebNotificationDetails(),
      ),
      payload: event.id?.toString(),
    );
  }

  int _notificationId(CalendarEvent event) {
    final value =
        '${event.id ?? ''}|${event.title}|${event.startTime.toIso8601String()}';
    var hash = 0;
    for (final codeUnit in value.codeUnits) {
      hash = (hash * 31 + codeUnit) & 0x7fffffff;
    }
    return hash == 0 ? 1 : hash;
  }
}
