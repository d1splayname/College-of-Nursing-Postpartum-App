import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'setup_screen.dart';
import 'privacy_and_terms.dart';

import '../themes/app_themes.dart'; // For color themes
import 'package:google_fonts/google_fonts.dart'; // For text
// Welcome Screen 
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Default theme (this screen only uses the default)
    final AppTheme theme = OceanTheme;

    return Scaffold(

      // Back button
      appBar: AppBar(
        backgroundColor: theme.tertiary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.text,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: theme.background,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // App Icon/Logo
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 64,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: theme.secondary,
                      width: 0.5,
                    ),
                  ),
                  child: Column (
                    children: [
                      Icon(Icons.favorite, size: 80, color: theme.tertiary),
                      const SizedBox(height: 40),
                      Text(
                        'Welcome to the \nFourth Trimester',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: theme.text,                              
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // Feature highlights
                _buildFeature(Icons.child_care, 'Track baby\'s feeding, sleep & diapers'),
                const SizedBox(height: 15),
                _buildFeature(Icons.emoji_people, 'Monitor your mood & self-care'),
                const SizedBox(height: 15),
                _buildFeature(Icons.favorite, 'Know what to expect'),
                const SizedBox(height: 15),
                _buildFeature(Icons.family_restroom_outlined, 'Let the people you trust help care for baby'),
                
                const Spacer(),
                
                // Get Started Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SetupScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.card,
                      foregroundColor: theme.text,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    final AppTheme theme = OceanTheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: theme.icon,
            size: 24,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: theme.text,
            ),
          ),
        ),
      ],
    );
  }
}