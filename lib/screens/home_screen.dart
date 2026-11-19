import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'babytracker_screen.dart';
import 'selfcare_screen.dart';
import '../growth_tracker_screen.dart';
import 'calendar_screen.dart';
import 'settings_screens/settings_screen.dart';
import '../themes/app_themes.dart';

class HomeScreen extends StatefulWidget {
  final String motherName;
  final String babyGender;
  final DateTime dueDate;
  final AppTheme theme;

  const HomeScreen({
    super.key,
    required this.motherName,
    required this.babyGender,
    required this.dueDate,
    required this.theme,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late AppTheme _currentTheme;

  @override
  void initState() {
    super.initState();
    _currentTheme = widget.theme;
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
      BabyTrackerScreen(babyGender: widget.babyGender, theme: theme),
      SelfCareScreen(motherName: widget.motherName, theme: theme),
      GrowthTrackerScreen(
        theme: theme,
        babyBirthday: DateTime.now().subtract(const Duration(days: 63)),
      ),
      CalendarScreen(postpartumStart: widget.dueDate, theme: theme),
      SettingsScreen(
        motherName: widget.motherName,
        babyGender: widget.babyGender,
        theme: theme,
        onThemeColorChanged: _updateThemeColor,
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(gradient: theme.background),
        child: screens[_selectedIndex],
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
