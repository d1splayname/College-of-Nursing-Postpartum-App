import 'package:flutter/material.dart';
//import 'welcome_screen.dart';
import 'privacy_and_terms.dart';
import '../auth_service.dart';

import '../themes/app_themes.dart'; // For color themes
import 'package:flutter_svg/flutter_svg.dart'; // For icons
import 'package:google_fonts/google_fonts.dart'; // For text

class AdditionalChild {
  String? gender;
  DateTime? dueDate;
}

// Setup Screen (Updated with gender and color selection)
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}
class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _confirmPasswordFocus = FocusNode();
  DateTime? _dueDate;
  String? _selectedGender;
  final List<AdditionalChild> _additionalChildren = [];
  AppTheme theme = OceanTheme;

  final Map<String, AppTheme> _themeOptions = {
    'Ocean': OceanTheme,
    'Sunrise': SunriseTheme,
    'Desert': DesertTheme,
  };

  @override
  void initState() {
    super.initState();
    _confirmPasswordFocus.addListener(() {
      if (!_confirmPasswordFocus.hasFocus &&
          _confirmPasswordController.text.isNotEmpty &&
          _passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Passwords do not match',
              style: TextStyle(color: theme.black),
            ),
            backgroundColor: theme.primary,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _motherNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.tertiary,
      appBar: AppBar(
        backgroundColor: theme.tertiary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We\'re happy you\'re here',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: theme.card,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Help us create your perfect experience',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: theme.primary,
              ),
            ),

            const SizedBox(height: 40),

            // Mother's Name
            Text(
              'Your Name',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.primary,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _motherNameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                filled: true,
                fillColor: theme.primary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.person, color: theme.tertiary),
              ),
            ),

            const SizedBox(height: 20),
            // Create Your Username
            Text(
              'Username',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.primary,
              ),
            ),
            const SizedBox(height:20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Create a Username',
                filled: true,
                fillColor: theme.primary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.person_outline, color: theme.tertiary),
              ),
            ),
            const SizedBox(height:20),
            // Password
            Text(
              'Choose a Password',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.primary,
              ),
            ),
            const SizedBox(height:20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter a Strong Password',
                filled: true,
                fillColor: theme.primary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.lock_outline, color: theme.tertiary),
              ),
            ),
            const SizedBox(height:20),
            Text(
              'Confirm Password',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.primary,
              ),
            ),
            const SizedBox(height:20),
            TextField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocus,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Re-enter your password',
                filled: true,
                fillColor: theme.primary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.lock_outline, color: theme.tertiary),
              ),
            ),
            const SizedBox(height:20),
            // Baby's Gender
            Text(
              'Baby\'s Gender',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.primary
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildGenderOption('Boy', Icons.male, const Color(0xFF84B3C3)),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildGenderOption('Girl', Icons.female, const Color(0xFFE89184)),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildGenderOption('I\'d prefer not to say', Icons.child_care, const Color(0xFFE6C96A)),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Due Date
            Text(
              'Due Date / Birth Date',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.primary
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
                  color: theme.primary,
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

            ...List.generate(_additionalChildren.length, (index) => _buildAdditionalChild(index)),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _additionalChildren.add(AdditionalChild());
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Child'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.card,
                  side: BorderSide(color: theme.card),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Color Theme Selection
            Text(
              'Choose Your Theme',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Don\'t worry, you can change this later.',
              style: TextStyle(
                fontSize: 14,
                color: theme.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: _themeOptions.entries.map((entry) {
                final isSelected = theme == entry.value;

                String iconPath;
                switch(entry.key) {
                  case 'Ocean':
                    iconPath = 'assets/icons/ocean.svg';
                    break;
                  case 'Sunrise':
                    iconPath = 'assets/icons/sunrise.svg';
                    break;
                  case 'Desert':
                    iconPath = 'assets/icons/desert.svg';
                    break;
                  default:
                    iconPath = 'assets/icons/ocean.svg';
                    break;
                }
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          theme = entry.value;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: theme.primary,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? entry.value.primary : Colors.grey.shade300,
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              iconPath,
                              width: 90,
                              height: 90,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle, color: entry.value.primary),
                          ],
                        ), // Column
                      ), // Container
                    ), // GestureDetector
                  ), // Padding
                ); // Expanded
              }).toList(), // map
            ), // Row

            const SizedBox(height: 40),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_motherNameController.text.isEmpty ||
                      _usernameController.text.isEmpty ||
                      _passwordController.text.isEmpty ||
                      _confirmPasswordController.text.isEmpty ||
                      _selectedGender == null ||
                      _dueDate == null ) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill in all fields',
                        style: TextStyle(color: theme.black)),
                        backgroundColor: theme.primary,
                      ),
                    );
                    return;
                  }

                  if (_passwordController.text != _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Passwords do not match',
                        style: TextStyle(color: theme.black)),
                        backgroundColor: theme.primary,
                      ),
                    );
                    return;
                  }

                  for (final child in _additionalChildren) {
                    if (child.gender == null || child.dueDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill in all fields for each child'),
                          backgroundColor: theme.card,
                        ),
                      );
                      return;
                    }
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyScreen(
                        motherName: _motherNameController.text,
                        username: _usernameController.text,
                        password: _passwordController.text,
                        babyGender: _selectedGender!,
                        dueDate: _dueDate!,
                        theme: theme,
                        additionalChildren: _additionalChildren.map((child) => ChildProfile(gender: child.gender!, dueDate: child.dueDate!)).toList(),
                        
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.card,
                  foregroundColor: theme.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Continue',
                  style: GoogleFonts.poppins(
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
          color: isSelected ? color.withValues(alpha: 0.3) : theme.primary,
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

  Widget _buildAdditionalGenderOption(int index, String label, IconData icon, Color color) {
    final isSelected = _additionalChildren[index].gender == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _additionalChildren[index].gender = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.3) : theme.primary,
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

  Widget _buildAdditionalChild(int index) {
    final child = _additionalChildren[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        Row(
          children: [
            Expanded(
              child: Text(
                'Child ${index + 2}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.card,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                setState(() {
                  _additionalChildren.removeAt(index);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Baby\'s Gender',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.primary
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildAdditionalGenderOption(index, 'Boy', Icons.male, const Color(0xFF84B3C3)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildAdditionalGenderOption(index, 'Girl', Icons.female, const Color(0xFFE89184)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildAdditionalGenderOption(index, 'I\'d prefer not to say', Icons.child_care, const Color(0xFFE6C96A)),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Text(
          'Due Date / Birth Date',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.primary
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: child.dueDate ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (context, datePickerChild) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF9C88D9),
                    ),
                  ),
                  child: datePickerChild!,
                );
              },
            );
            if (picked != null) {
              setState(() {
                child.dueDate = picked;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Color(0xFF9C88D9)),
                const SizedBox(width: 15),
                Text(
                  child.dueDate == null
                      ? 'Select date'
                      : '${child.dueDate!.month}/${child.dueDate!.day}/${child.dueDate!.year}',
                  style: TextStyle(
                    fontSize: 16,
                    color: child.dueDate == null ? Colors.grey : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}