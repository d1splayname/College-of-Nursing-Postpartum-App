import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'privacy_and_terms.dart';

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
            
            // Create Your Username
            const Text(
              'Username',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height:10),

            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Create a Username',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF9C88D9)),
              ),
            ),
            const SizedBox(height:25),

            // Password 
            const Text(
              'Choose a Password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height:25),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter a Strong Password',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9C88D9)),
              ),
            ),
            const SizedBox(height:25),

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
                      _usernameController.text.isEmpty ||
                      _passwordController.text.isEmpty ||
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
                        username: _usernameController.text,
                        password: _passwordController.text,
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