import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'babytracker_screen.dart';
import 'selfcare_screen.dart';
import '../growth_tracker_screen.dart';
import 'settings_screens/settings_screen.dart';

// Home Screen (Updated with personalization and theme color)
class HomeScreen extends StatefulWidget {
  final String motherName;
  final String babyGender;
  final DateTime dueDate;
  final Color themeColor;

  const HomeScreen({
    super.key,
    required this.motherName,
    required this.babyGender,
    required this.dueDate,
    required this.themeColor,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Color _currentThemeColor;

  @override
  void initState() {
    super.initState();
    _currentThemeColor = widget.themeColor;
  }

  void _updateThemeColor(Color newColor) {
    setState(() {
      _currentThemeColor = newColor;
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
    final List<Widget> screens = [
      DashboardScreen(
        motherName: widget.motherName,
        babyGender: widget.babyGender,
        themeColor: _currentThemeColor,
      ),
      BabyTrackerScreen(babyGender: widget.babyGender, themeColor: _currentThemeColor),
      SelfCareScreen(themeColor: _currentThemeColor),
      GrowthTrackerScreen(themeColor: _currentThemeColor),
      SettingsScreen(
        motherName: widget.motherName,
        babyGender: widget.babyGender,
        themeColor: _currentThemeColor,
        onThemeColorChanged: _updateThemeColor,
      ),
    ];

    return Scaffold(
    backgroundColor: _getBackgroundColor(_currentThemeColor),
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: _currentThemeColor.withValues(alpha: 0.2),
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
          selectedItemColor: _currentThemeColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.child_care),
              label: 'Baby',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Self-Care',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.park),  // Plant icon!
              label: 'Growth',
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