import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:flutter_svg/flutter_svg.dart'; 
import '../themes/app_themes.dart'; 

import 'login_screen.dart';
import 'setup_screen.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Default theme (this screen only uses the default)
    final AppTheme theme = OceanTheme;

    return Scaffold(

      // Back button to navigate to the login screen
      appBar: AppBar(
        backgroundColor: theme.tertiary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: theme.background,
        ),
        child: SafeArea(
          child: Stack(
            children: [

              // Moon Icon
              Positioned(
                left: MediaQuery.of(context).size.width * 0.04,
                top: MediaQuery.of(context).size.height * 0.1,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.9,
                    child: SvgPicture.asset(
                      'assets/icons/moon.svg',
                      width: (MediaQuery.of(context).size.width * 0.15)
                          .clamp(0.0, 120.0),
                    ),
                  ),
                ),
              ),

              // Cloud Icon
              Positioned(
                right: MediaQuery.of(context).size.width * 0.2,
                top: MediaQuery.of(context).size.height * 0.07,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.9,
                    child: SvgPicture.asset(
                      'assets/icons/cloud.svg',
                      width: (MediaQuery.of(context).size.width * 0.5)
                          .clamp(0.0, 100.0),
                    ),
                  ),
                ),
              ),              
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24),

                      // Main Logo 
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 85,
                          vertical: 64,
                        ),
                        decoration: BoxDecoration(
                          color: theme.primary,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: theme.card.withOpacity(0.7),
                            width: 0.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.black.withOpacity(0.3),
                              blurRadius: 20,
                            ),
                          ],                 
                        ),
                        child: Column (
                          children: [
                            Text(
                              'Welcome to the \nFourth Trimester',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: theme.black,                              
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'Your postpartum journey companion',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
                      ),

                      const SizedBox(height: 50),

                      // Feature highlights
                      _buildFeature(
                        Icons.child_care,
                        'Track baby\'s feeding, sleep & diapers',
                      ),
                      const SizedBox(height: 15),
                      _buildFeature(
                        Icons.emoji_people,
                        'Monitor your mood & self-care',
                      ),
                      const SizedBox(height: 15),
                      _buildFeature(Icons.favorite, 'Know what to expect'),
                      const SizedBox(height: 15),
                      _buildFeature(
                        Icons.family_restroom_outlined,
                        'Let the people you trust help care for baby',
                      ),

                      const SizedBox(height: 24),

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
                            foregroundColor: theme.black,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            side: BorderSide(
                              color: theme.tertiary.withOpacity(0.2),
                              width: 0.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                            shadowColor: theme.black,
                          ),
                          child: Text(
                            'Get Started',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
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
            color: theme.card,
            size: 24,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: theme.text,
            ),
          ),
        ),
      ],
    );
  }
}
