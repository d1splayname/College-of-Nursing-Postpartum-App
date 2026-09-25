import 'package:flutter/material.dart';
import '../auth_service.dart';
import 'welcome_screen.dart';
import 'home_screen.dart';

import '../themes/app_themes.dart'; // For color themes
import 'package:flutter_svg/flutter_svg.dart'; // For icons
import 'package:google_fonts/google_fonts.dart'; // For text

// Login Screen 
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your username and password.'),
          backgroundColor: Color(0xFF16587B),
        ), 
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await AuthService().login(
        username: username,
        password: password,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged in as ${response.user.username}'),
          backgroundColor: const Color(0xFF9C88D9),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            motherName: response.user.username,
            babyGender: 'Neutral',
            dueDate: DateTime.now(),
            theme: OceanTheme,
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: const Color(0xFFD4A5A5),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: const Color(0xFFD4A5A5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Default theme (this screen only uses the default)
    final AppTheme theme = OceanTheme;
    
    return Scaffold(
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

                child: Opacity(
                  opacity: 0.9,
                  child: SvgPicture.asset(
                    'assets/icons/moon.svg',
                    width: (MediaQuery.of(context).size.width * 0.15).clamp(0.0, 120.0),
                  ),
                ),
              ),

              // Cloud Icon
              Positioned(
                right: MediaQuery.of(context).size.width * 0.2,
                top: MediaQuery.of(context).size.height * 0.07,
                child: Opacity(
                  opacity: 0.9,
                  child: SvgPicture.asset(
                    'assets/icons/cloud.svg',
                    width: (MediaQuery.of(context).size.width * 0.5).clamp(0.0, 100.0),
                  ),
                ),
              ),

              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: [
                      const SizedBox(height: 30),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 60),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 100,
                            vertical: 84,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primary,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: theme.secondary,
                              width: 0.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.text.withOpacity(0.4),
                                blurRadius: 50,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Text(
                            'Welcome back',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 46,
                              fontWeight: FontWeight.bold,
                              color: theme.text,
                            ),
                          ),
                        ),
                      ), 
                      const SizedBox(height: 24),
                      Text(
                        'Sign in to continue your journey',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: theme.text,
                          shadows: [
                            Shadow(
                              color: theme.text.withOpacity(0.5),
                              offset: const Offset(0,0),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          filled: true,
                          fillColor: theme.primary,
                          prefixIcon: Icon(Icons.person, color: theme.text),
                          
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17),
                            borderSide: BorderSide(
                              color: theme.secondary,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17),
                            borderSide: BorderSide(
                              color: theme.text,
                              width: 1,
                            ),
                          ), 
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor: theme.primary,
                          prefixIcon: Icon(Icons.lock, color: theme.text),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17),
                            borderSide: BorderSide(
                              color: theme.secondary,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17),
                            borderSide: BorderSide(
                              color: theme.text,
                              width: 1,
                            ),
                          ),                      
                        ),
                      ),
                      const SizedBox(height: 36),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.card,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            side: BorderSide(
                              color: theme.tertiary,
                              width: 0.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                            shadowColor: Colors.black,
                          ),
                          child: Text(
                            _isLoading ? 'Signing In...' : 'Sign In',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.text,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 64,
                              vertical: 16,
                            ),
                          ),
                          child: const Text(
                            'Create an account',
                            style: TextStyle(
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ), //end of stack            
        ),
      ),
    );
  }
}
