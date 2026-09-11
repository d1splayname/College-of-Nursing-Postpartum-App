import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'terms_and_conditions.dart';

/*

    Imports from the screens folder

*/

import 'screens/login_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/privacy_and_terms.dart';

import 'growth_tracker_screen.dart';
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/selfcare_screen.dart';
import 'screens/babytracker_screen.dart';
import 'screens/settings_screens/settings_screen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Postpartum Care',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFFFFFBF5), // Cream background
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
