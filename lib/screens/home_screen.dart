import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'babytracker_screen.dart';
import 'selfcare_screen.dart';
import '../growth_tracker_screen.dart';
import 'calendar_screen.dart';
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

  void _updateThemeColor(AppTheme newTheme){
    setState(() {
      _currentTheme = newTheme;
    });
  }

  Color _getBackgroundColor(Color themeColor) {
    if (themeColor == const Color(0xFFAEC6FF)) {
      // Boy Blue - Very light blue
      return const Color(0xFFF0F4FF);
    } else if (themeColor == const Color(0xFFFFB5E8)) {
      // Girl Pink - Very light pink
      return const Color(0xFFFFF5FA);
    } else {
      // Neutral Yellow - Warm cream
      return const Color(0xFFFFFBF5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _currentTheme;

    final List<Widget> screens = [
      DashboardScreen(
        motherName: widget.motherName,
        babyGender: widget.babyGender,
        themeColor: theme.primary,
      ),
      BabyTrackerScreen(
        babyGender: widget.babyGender, 
        themeColor: theme.primary,
      ),
      SelfCareScreen(
        themeColor: theme.primary,
      ),
      GrowthTrackerScreen(
        themeColor: theme.primary,
      ),
      CalendarScreen(
        postpartumStart: widget.dueDate,
        themeColor: theme.primary,
      ),
      SettingsScreen(
        motherName: widget.motherName,
        babyGender: widget.babyGender,
        theme: theme,
        onThemeColorChanged: _updateThemeColor,
      ),
    ];

    
    return Scaffold(
      body: Container (
        decoration: BoxDecoration(
          gradient: theme.background,
        ),
        child: screens[_selectedIndex],
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: theme.primary.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: theme.card,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.child_care),
              label: 'Baby',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Self-Care',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.park), // Plant icon!
              label: 'Growth',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
