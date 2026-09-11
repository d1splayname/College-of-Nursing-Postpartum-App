import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'setup_screen.dart';
import 'privacy_and_terms.dart';

// Welcome Screen 
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Back button
      appBar: AppBar(
        backgroundColor: Color(0xFFE0BBE4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF9C88D9),
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0BBE4),
              Color(0xFFF8F4FF),
            ],
          ),
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
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9C88D9).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 80,
                    color: Color(0xFF9C88D9),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                const Text(
                  'We\'re glad you\'re here.',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9C88D9),
                  ),
                ),
                
                const SizedBox(height: 15),
                
                Text(
                  'Your postpartum journey companion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
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
                      backgroundColor: const Color(0xFF9C88D9),
                      foregroundColor: Colors.white,
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
            color: const Color(0xFF9C88D9),
            size: 24,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}