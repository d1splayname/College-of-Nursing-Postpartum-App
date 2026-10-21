import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'babytracker_screen.dart';
import 'selfcare_screen.dart';
import '../growth_tracker_screen.dart';
import 'calendar_screen.dart';
import 'settings_screens/settings_screen.dart';
import '../themes/app_themes.dart';
import '../calendar_service.dart';
import '../notification_service.dart';
import '../auth_service.dart';

class HomeScreen extends StatefulWidget {
  final String motherName;
  final String babyGender;
  final DateTime dueDate;
  final List<ChildProfile> children;
  final AppTheme theme;

  const HomeScreen({
    super.key,
    required this.motherName,
    required this.babyGender,
    required this.dueDate,
    this.children = const [],
    required this.theme,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late AppTheme _currentTheme;
  final CalendarService _calendarService = CalendarService();
  final NotificationService _notificationService = NotificationService.instance;
  List<CalendarEvent> _calendarEvents = [];

  @override
  void initState() {
    super.initState();
    _currentTheme = widget.theme;
    _loadCalendarEvents();
  }

  Future<void> _loadCalendarEvents() async {
    final localMilestones = _calendarService.localMilestones(widget.dueDate);
    try {
      final remoteEvents = await _calendarService.fetchEvents();
      if (!mounted) return;
      setState(() {
        _calendarEvents = [...remoteEvents, ...localMilestones];
      });
      await _notificationService.syncEvents(_calendarEvents);
    } on ApiException {
      if (!mounted) return;
      setState(() => _calendarEvents = localMilestones);
    } catch (_) {
      if (!mounted) return;
      setState(() => _calendarEvents = localMilestones);
    }
  }

  List<CalendarEvent> get _upcomingEvents {
    final now = DateTime.now();
    final cutoff = now.add(const Duration(days: 7));
    return _calendarEvents
        .where(
          (event) =>
              event.startTime.isAfter(now) && event.startTime.isBefore(cutoff),
        )
        .toList()
      ..sort((first, second) => first.startTime.compareTo(second.startTime));
  }

  Future<void> _showNotifications() async {
    await _loadCalendarEvents();
    if (!mounted) return;

    await _notificationService.requestPermission();
    await _notificationService.syncEvents(_calendarEvents);
    if (!mounted) return;
    final upcoming = _upcomingEvents;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upcoming notifications'),
        content: upcoming.isEmpty
            ? const Text('You have no events in the next 7 days.')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: upcoming
                    .map(
                      (event) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.notifications_active_outlined,
                          color: _currentTheme.primary,
                        ),
                        title: Text(event.title),
                        subtitle: Text(
                          MaterialLocalizations.of(
                            context,
                          ).formatMediumDate(event.startTime.toLocal()),
                        ),
                      ),
                    )
                    .toList(),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _updateThemeColor(AppTheme newTheme) {
    setState(() {
      _currentTheme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = _currentTheme;
    final screens = [
      DashboardScreen(
        motherName: widget.motherName,
        babyGender: widget.babyGender,
        theme: theme,
      ),
      BabyTrackerScreen(babyGender: widget.babyGender, children: widget.children, theme: theme),
      SelfCareScreen(motherName: widget.motherName, theme: theme),
      GrowthTrackerScreen(
        theme: theme,
        babyBirthday: DateTime.now().subtract(const Duration(days: 63)),
      ),
      CalendarScreen(postpartumStart: widget.dueDate, theme: theme),
      SettingsScreen(
        motherName: widget.motherName,
        babyGender: widget.babyGender,
        children: widget.children,
        theme: theme,
        onThemeColorChanged: _updateThemeColor,
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: theme.background),
            child: screens[_selectedIndex],
          ),
          if (_selectedIndex != 4)
            Positioned(
              top: 4,
              right: 12,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: _showNotifications,
                tooltip: 'Upcoming notifications',
                icon: Badge(
                  isLabelVisible: _upcomingEvents.isNotEmpty,
                  label: Text('${_upcomingEvents.length}'),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: theme.text.withValues(alpha: 0.7),
                    size: 21,
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: theme.primary,
            borderRadius: BorderRadius.circular(35),
            border: Border.all(
              color: theme.text.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(icon: Icons.home, index: 0),
                  _buildNavItem(icon: Icons.child_friendly, index: 1),
                  _buildNavItem(icon: Icons.favorite, index: 2),
                  _buildNavItem(icon: Icons.park, index: 3),
                  _buildNavItem(icon: Icons.calendar_month, index: 4),
                  _buildNavItem(icon: Icons.settings, index: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    final isSelected = _selectedIndex == index;
    final theme = _currentTheme;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.text.withValues(alpha: 0.15)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isSelected ? theme.text : theme.text.withValues(alpha: 0.5),
            size: 24,
          ),
        ),
      ),
    );
  }
}