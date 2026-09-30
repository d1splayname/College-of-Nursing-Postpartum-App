import 'package:flutter/material.dart';

import '../auth_service.dart';
import '../calendar_service.dart';

class CalendarScreen extends StatefulWidget {
  final DateTime postpartumStart;
  final Color themeColor;

  const CalendarScreen({
    super.key,
    required this.postpartumStart,
    required this.themeColor,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarService _calendarService = CalendarService();
  late DateTime _selectedDate;
  late DateTime _visibleMonth;
  late List<CalendarEvent> _events;
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _visibleMonth = DateTime(_selectedDate.year, _selectedDate.month);
    _events = _calendarService.localMilestones(widget.postpartumStart);
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final remoteEvents = await _calendarService.fetchEvents();
      if (!mounted) return;
      setState(() {
        _events = _mergeEvents(remoteEvents);
        _isLoading = false;
        _loadError = null;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = error.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = 'Could not connect to the calendar service.';
      });
    }
  }

  List<CalendarEvent> _mergeEvents(List<CalendarEvent> remoteEvents) {
    final remoteMilestones = remoteEvents
        .where((event) => event.source == 'generated')
        .map((event) => event.startTime.toLocal().toIso8601String())
        .toSet();
    final localOnly = _calendarService
        .localMilestones(widget.postpartumStart)
        .where(
          (event) =>
              !remoteMilestones.contains(event.startTime.toIso8601String()),
        );
    return [...remoteEvents, ...localOnly]
      ..sort((first, second) => first.startTime.compareTo(second.startTime));
  }

  List<CalendarEvent> get _selectedEvents => _events.where((event) {
    final date = event.startTime.toLocal();
    return date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
  }).toList();

  void _changeMonth(int amount) {
    setState(() {
      _visibleMonth = DateTime(
        _visibleMonth.year,
        _visibleMonth.month + amount,
      );
    });
  }

  Future<void> _addEvent() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty) return;
              try {
                final start = DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  _selectedDate.day,
                  9,
                );
                final event = await _calendarService.createEvent(
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  startTime: start,
                  endTime: start.add(const Duration(hours: 1)),
                );
                if (!context.mounted) return;
                setState(() => _events = [..._events, event]);
                Navigator.pop(context, true);
              } on ApiException catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(error.message)));
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (result == true && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Calendar',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: widget.themeColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _addEvent,
                    tooltip: 'Add appointment',
                    icon: Icon(
                      Icons.add_circle,
                      color: widget.themeColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading) const LinearProgressIndicator(minHeight: 2),
            if (_loadError != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Text(
                  'Showing local milestones. $_loadError',
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
              ),
            _buildMonthHeader(),
            _buildCalendarGrid(),
            const SizedBox(height: 12),
            _buildSelectedDay(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthHeader() {
    final monthName = MaterialLocalizations.of(
      context,
    ).formatMonthYear(_visibleMonth);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _changeMonth(-1),
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: Text(
              monthName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: () => _changeMonth(1),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysInMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + 1,
      0,
    ).day;
    final leadingDays = firstDay.weekday % 7;
    final cells = <Widget>[];
    const weekdayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    cells.addAll(
      weekdayLabels.map(
        (label) => Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
    for (var index = 0; index < leadingDays; index++) {
      cells.add(const SizedBox());
    }
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_visibleMonth.year, _visibleMonth.month, day);
      final isSelected =
          date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day;
      final hasEvent = _events.any((event) {
        final eventDate = event.startTime.toLocal();
        return eventDate.year == date.year &&
            eventDate.month == date.month &&
            eventDate.day == date.day;
      });
      cells.add(
        GestureDetector(
          onTap: () => setState(() => _selectedDate = date),
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isSelected ? widget.themeColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                if (hasEvent)
                  Icon(
                    Icons.circle,
                    size: 5,
                    color: isSelected ? Colors.white : widget.themeColor,
                  ),
              ],
            ),
          ),
        ),
      );
    }
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.8,
            children: cells,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDay() {
    final formattedDate = MaterialLocalizations.of(
      context,
    ).formatMediumDate(_selectedDate);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            formattedDate,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_selectedEvents.isEmpty)
            Text(
              'No events scheduled.',
              style: TextStyle(color: Colors.grey[600]),
            )
          else
            ..._selectedEvents.map(_buildEventTile),
        ],
      ),
    );
  }

  Widget _buildEventTile(CalendarEvent event) {
    final isMilestone = event.eventType == 'postpartum_milestone';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.themeColor.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isMilestone ? Icons.favorite : Icons.event,
            color: widget.themeColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (event.description.isNotEmpty)
                  Text(
                    event.description,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
              ],
            ),
          ),
          if (event.source == 'personal' && event.id != null)
            IconButton(
              onPressed: () => _deleteEvent(event),
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete appointment',
            ),
        ],
      ),
    );
  }

  Future<void> _deleteEvent(CalendarEvent event) async {
    try {
      await _calendarService.deleteEvent(event.id!);
      if (!mounted) return;
      setState(() => _events.remove(event));
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }
}
