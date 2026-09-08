import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'growth_tracker_screen.dart';
import 'terms_and_conditions.dart';

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
          backgroundColor: Color(0xFFD4A5A5),
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
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
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
    return Scaffold(
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9C88D9).withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 60,
                      color: Color(0xFF9C88D9),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Welcome back',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9C88D9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue your journey',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.person, color: Color(0xFF9C88D9)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.lock, color: Color(0xFF9C88D9)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C88D9),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        _isLoading ? 'Signing In...' : 'Sign In',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                      );
                    },
                    child: const Text(
                      'Continue to setup',
                      style: TextStyle(
                        color: Color(0xFF9C88D9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Welcome Screen
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Welcome, Mama',
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
                _buildFeature(Icons.favorite, 'Monitor your mood & self-care'),
                const SizedBox(height: 15),
                _buildFeature(Icons.notifications, 'Gentle reminders for your well-being'),
                
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

// Setup Screen (Updated with gender and color selection)
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _motherNameController = TextEditingController();
  DateTime? _dueDate;
  String? _selectedGender;
  Color? _selectedColor;

  final Map<String, Color> _colorOptions = {
    'Boy (Blue)': const Color(0xFFAEC6FF),
    'Girl (Pink)': const Color(0xFFFFB5E8),
    'Neutral (Yellow/Nude)': const Color(0xFFFFF4C1),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF9C88D9)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Let\'s personalize',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9C88D9),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Help us create your perfect experience',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Mother's Name
            const Text(
              'Your Name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _motherNameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.person, color: Color(0xFF9C88D9)),
              ),
            ),
            
            const SizedBox(height: 25),
            
            // Baby's Gender
            const Text(
              'Baby\'s Gender',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildGenderOption('Boy', Icons.male, const Color(0xFFAEC6FF)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildGenderOption('Girl', Icons.female, const Color(0xFFFFB5E8)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildGenderOption('Neutral', Icons.child_care, const Color(0xFFFFF4C1)),
                ),
              ],
            ),
            
            const SizedBox(height: 25),
            
            // Due Date
            const Text(
              'Due Date / Birth Date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFF9C88D9),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    _dueDate = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF9C88D9)),
                    const SizedBox(width: 15),
                    Text(
                      _dueDate == null
                          ? 'Select date'
                          : '${_dueDate!.month}/${_dueDate!.day}/${_dueDate!.year}',
                      style: TextStyle(
                        fontSize: 16,
                        color: _dueDate == null ? Colors.grey : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 25),
            
            // Color Theme Selection
            const Text(
              'Choose Your Color Theme',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ..._colorOptions.entries.map((entry) {
              final isSelected = _selectedColor == entry.value;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = entry.value;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected ? entry.value : Colors.grey.shade300,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: entry.value,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      if (isSelected)
                        Icon(Icons.check_circle, color: entry.value),
                    ],
                  ),
                ),
              );
            }),
            
            const SizedBox(height: 40),
            
            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_motherNameController.text.isEmpty ||
                      _selectedGender == null ||
                      _dueDate == null ||
                      _selectedColor == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields'),
                        backgroundColor: Color(0xFFD4A5A5),
                      ),
                    );
                    return;
                  }
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyScreen(
                        motherName: _motherNameController.text,
                        babyGender: _selectedGender!,
                        dueDate: _dueDate!,
                        themeColor: _selectedColor!,
                      ),
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
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(String label, IconData icon, Color color) {
    final isSelected = _selectedGender == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.3) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 35),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Privacy & Terms Screen
class PrivacyScreen extends StatefulWidget {
  final String motherName;
  final String babyGender;
  final DateTime dueDate;
  final Color themeColor;

  const PrivacyScreen({
    super.key,
    required this.motherName,
    required this.babyGender,
    required this.dueDate,
    required this.themeColor,
  });

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: widget.themeColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy & Terms',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: widget.themeColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your data, your control',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: _buildTermsContent(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Agreement Checkbox
              GestureDetector(
                onTap: () {
                  setState(() {
                    _agreedToTerms = !_agreedToTerms;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _agreedToTerms ? widget.themeColor : Colors.white,
                        border: Border.all(
                          color: _agreedToTerms ? widget.themeColor : Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: _agreedToTerms
                          ? const Icon(Icons.check, size: 18, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'I agree to the privacy policy and terms of use',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsAndConditionsScreen(
                        themeColor: widget.themeColor,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.themeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: widget.themeColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.open_in_new, color: widget.themeColor, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'View Full Terms & Conditions',
                        style: TextStyle(
                          color: widget.themeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _agreedToTerms
                      ? () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                motherName: widget.motherName,
                                babyGender: widget.babyGender,
                                dueDate: widget.dueDate,
                                themeColor: widget.themeColor,
                              ),
                            ),
                            (route) => false,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.themeColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: const Text(
                    'Start My Journey',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPrivacySection(
          Icons.lock,
          'Data Privacy',
          'All your personal information and baby tracking data is stored securely on your device. We do not share or sell your data to third parties.',
        ),
        const SizedBox(height: 20),
        _buildPrivacySection(
          Icons.health_and_safety,
          'Health Information',
          'This app is for informational purposes only and should not replace professional medical advice. Please consult with your healthcare provider for medical concerns.',
        ),
        const SizedBox(height: 20),
        _buildPrivacySection(
          Icons.notifications,
          'Reminders',
          'We may send you gentle notifications to help with self-care reminders. You can disable these anytime in settings.',
        ),
        const SizedBox(height: 20),
        _buildPrivacySection(
          Icons.update,
          'Updates',
          'We may update these terms from time to time. Continued use of the app means you accept any changes.',
        ),
      ],
    );
  }

  Widget _buildPrivacySection(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: widget.themeColor, size: 28),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


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

// Dashboard Screen (Updated with personalization and theme color)
class DashboardScreen extends StatelessWidget {
  final String motherName;
  final String babyGender;
  final Color themeColor;

  const DashboardScreen({
    super.key,
    required this.motherName,
    required this.babyGender,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $motherName 💕',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You\'re doing amazing with your baby $babyGender!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),

            // Quick Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Last Feeding',
                    '2h ago',
                    Icons.restaurant,
                    themeColor,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatCard(
                    'Last Sleep',
                    '3h ago',
                    Icons.bedtime,
                    themeColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            const Text(
              'Today\'s Goals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // Self-care checklist
            _buildChecklistItem('Drink 8 glasses of water', true, themeColor),
            _buildChecklistItem('Take your vitamins', true, themeColor),
            _buildChecklistItem('Rest for 30 minutes', false, themeColor),
            _buildChecklistItem('Eat a healthy meal', false, themeColor),

            const Spacer(),

            // Encouragement card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.spa, color: themeColor, size: 30),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Text(
                      'Remember: Your well-being matters too',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text, bool checked, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.circle_outlined,
            color: checked ? themeColor : Colors.grey,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              decoration: checked ? TextDecoration.lineThrough : null,
              color: checked ? Colors.grey : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// Baby Tracker Screen (Updated with gender and theme color)
class BabyTrackerScreen extends StatefulWidget {
  final String babyGender;
  final Color themeColor;

  const BabyTrackerScreen({
    super.key,
    required this.babyGender,
    required this.themeColor,
  });

  @override
  State<BabyTrackerScreen> createState() => _BabyTrackerScreenState();
}

class _BabyTrackerScreenState extends State<BabyTrackerScreen> {
  List<Map<String, dynamic>> activities = [];

  @override
  void initState() {
    super.initState();
    activities = [
      {'type': 'Feeding', 'time': '2 hours ago', 'icon': Icons.restaurant, 'color': widget.themeColor},
      {'type': 'Diaper', 'time': '1 hour ago', 'icon': Icons.child_care, 'color': widget.themeColor.withValues(alpha: 0.7)},
      {'type': 'Sleep', 'time': '3 hours ago', 'icon': Icons.bedtime, 'color': widget.themeColor.withValues(alpha: 0.5)},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Baby Tracker 👶',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: widget.themeColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tracking your ${widget.babyGender.toLowerCase()}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),

            // Quick Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  'Feed',
                  Icons.restaurant,
                  widget.themeColor,
                  () => _addActivity('Feeding', Icons.restaurant),
                ),
                _buildActionButton(
                  'Diaper',
                  Icons.child_care,
                  widget.themeColor.withValues(alpha: 0.7),
                  () => _addActivity('Diaper', Icons.child_care),
                ),
                _buildActionButton(
                  'Sleep',
                  Icons.bedtime,
                  widget.themeColor.withValues(alpha: 0.5),
                  () => _addActivity('Sleep', Icons.bedtime),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // Activity List
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: (activity['color'] as Color).withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (activity['color'] as Color).withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            activity['icon'] as IconData,
                            color: activity['color'] as Color,
                            size: 25,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity['type'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                activity['time'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 35),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addActivity(String type, IconData icon) {
    setState(() {
      activities.insert(0, {
        'type': type,
        'time': 'Just now',
        'icon': icon,
        'color': widget.themeColor,
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type logged!'),
        backgroundColor: widget.themeColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Self-Care Screen (Updated with theme color)
class SelfCareScreen extends StatefulWidget {
  final Color themeColor;

  const SelfCareScreen({super.key, required this.themeColor});

  @override
  State<SelfCareScreen> createState() => _SelfCareScreenState();
}

class _SelfCareScreenState extends State<SelfCareScreen> {
  String selectedMood = 'Good';
  
  final List<Map<String, dynamic>> moods = [
    {'emoji': '😊', 'label': 'Good'},
    {'emoji': '😌', 'label': 'Calm'},
    {'emoji': '😫', 'label': 'Tired'},
    {'emoji': '😢', 'label': 'Sad'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Self-Care 💖',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: widget.themeColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'How are you feeling today?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),

            // Mood Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: moods.map((mood) {
                final isSelected = selectedMood == mood['label'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMood = mood['label'] as String;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? widget.themeColor.withValues(alpha: 0.3)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected
                            ? widget.themeColor
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          mood['emoji'] as String,
                          style: const TextStyle(fontSize: 35),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          mood['label'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            const Text(
              'Daily Reminders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // Reminders List
            Expanded(
              child: ListView(
                children: [
                  _buildReminderCard(
                    'Hydration',
                    'Drink a glass of water',
                    Icons.local_drink,
                    widget.themeColor,
                  ),
                  _buildReminderCard(
                    'Nutrition',
                    'Have a healthy snack',
                    Icons.restaurant_menu,
                    widget.themeColor.withValues(alpha: 0.8),
                  ),
                  _buildReminderCard(
                    'Rest',
                    'Take a 15-minute break',
                    Icons.chair,
                    widget.themeColor.withValues(alpha: 0.6),
                  ),
                  _buildReminderCard(
                    'Movement',
                    'Gentle stretching',
                    Icons.self_improvement,
                    widget.themeColor.withValues(alpha: 0.4),
                  ),
                  _buildReminderCard(
                    'Connection',
                    'Call a friend or family',
                    Icons.phone,
                    widget.themeColor.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),

            // Affirmation
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.themeColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    '✨ Daily Affirmation ✨',
                    style: TextStyle(
                      color: widget.themeColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '"I am strong, capable, and deserving of rest"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(String title, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 25),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.notifications_outlined, color: Colors.grey[400]),
        ],
      ),
    );
  }
}

// Settings Screen with Theme Changer
class SettingsScreen extends StatelessWidget {
  final String motherName;
  final String babyGender;
  final Color themeColor;
  final Function(Color) onThemeColorChanged;

  const SettingsScreen({
    super.key,
    required this.motherName,
    required this.babyGender,
    required this.themeColor,
    required this.onThemeColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          20 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings ⚙️',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Manage your account and preferences',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),

            // Profile Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(Icons.person, color: themeColor),
                      const SizedBox(width: 10),
                      Text(
                        motherName,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.child_care, color: themeColor),
                      const SizedBox(width: 10),
                      Text(
                        'Baby Gender: $babyGender',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Change Theme Color Option
            _buildSettingOption(
              context,
              'Change Theme Color',
              'Choose your preferred color theme',
              Icons.palette_outlined,
              themeColor,
              () {
                _showColorPicker(context);
              },
            ),

            _buildSettingOption(
              context,
              'Notifications',
              'Manage reminder settings',
              Icons.notifications_outlined,
              themeColor,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Notification settings coming soon!'),
                    backgroundColor: themeColor,
                  ),
                );
              },
            ),

            _buildSettingOption(
              context,
              'Privacy',
              'View privacy policy',
              Icons.lock_outline,
              themeColor,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsAndConditionsScreen(
                      themeColor: themeColor,
                    ),
                  ),
                );
              },
            ),

            _buildSettingOption(
              context,
              'Help & Support',
              'Get help and contact us',
              Icons.help_outline,
              themeColor,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Support coming soon!'),
                    backgroundColor: themeColor,
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Clear navigation stack and go to welcome
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const WelcomeScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Logout'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    final Map<String, Color> colorOptions = {
      'Boy (Blue)': const Color(0xFFAEC6FF),
      'Girl (Pink)': const Color(0xFFFFB5E8),
      'Neutral (Yellow/Nude)': const Color(0xFFFFF4C1),
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Theme Color'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: colorOptions.entries.map((entry) {
              final isSelected = themeColor == entry.value;
              return GestureDetector(
                onTap: () {
                  onThemeColorChanged(entry.value);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Theme changed to ${entry.key}'),
                      backgroundColor: entry.value,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected ? entry.value : Colors.grey.shade300,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: entry.value,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      if (isSelected)
                        Icon(Icons.check_circle, color: entry.value),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildSettingOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 25),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 18),
          ],
        ),
      ),
    );
  }
}
