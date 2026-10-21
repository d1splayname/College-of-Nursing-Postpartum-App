import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'babytracker_screen.dart';
import 'selfcare_screen.dart';
import '../growth_tracker_screen.dart';
import 'settings_screens/settings_screen.dart';

import '../themes/app_themes.dart'; // For color themes

// Home Screen (Updated with personalization and theme color)
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

    final List<Widget> screens = [
      DashboardScreen(
        motherName: widget.motherName,
        babyGender: widget.babyGender,
        theme: theme,
      ),
      BabyTrackerScreen(
        babyGender: widget.babyGender,
        theme: theme,
      ),
      SelfCareScreen(themeColor: theme.primary),
      GrowthTrackerScreen(themeColor: theme.primary),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          child: Container(
            height: 60.0,
            decoration: BoxDecoration(
              color: theme.primary,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  icon: Icons.home,
                  index: 0,
                  theme: theme,
                ),
                _buildNavItem(
                  icon: Icons.child_friendly,
                  index: 1,
                  theme: theme,
                ),
                _buildNavItem(
                  icon: Icons.favorite,
                  index: 2,
                  theme: theme,
                ),
                _buildNavItem(
                  icon: Icons.park,
                  index: 3,
                  theme: theme,
                ),
                _buildNavItem(
                  icon: Icons.settings,
                  index: 4,
                  theme: theme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required AppTheme theme,
  }) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? theme.text : theme.text.withOpacity(0.7),
              size: 30,
            ),
            const SizedBox(height: 4),

          ],
        ),
      ),
    );
  }
}
