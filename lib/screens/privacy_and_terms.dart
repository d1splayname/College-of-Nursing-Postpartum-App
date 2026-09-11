import 'package:flutter/material.dart';
import '../auth_service.dart';
import 'setup_screen.dart';
import 'home_screen.dart';
import '../terms_and_conditions.dart';

// Privacy & Terms Screen
class PrivacyScreen extends StatefulWidget {
  final String motherName;
  final String username;
  final String password;
  final String babyGender;
  final DateTime dueDate;
  final Color themeColor;

  const PrivacyScreen({
    super.key,
    required this.motherName,
    required this.username,
    required this.password,
    required this.babyGender,
    required this.dueDate,
    required this.themeColor,
  });

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _agreedToTerms = false;
  bool _isCreatingAccount = false;

  Future<void> _createAccount() async {
    setState(() {
      _isCreatingAccount = true;
    });
    try {
      await AuthService().signup(
        name: widget.motherName,
        username: widget.username,
        password: widget.password,
      );
      if (!mounted) return;
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
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not create account.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingAccount = false;
        });
      }
    }
  }

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
                  onPressed: _agreedToTerms && !_isCreatingAccount
                      ? _createAccount
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
                  child: Text(
                    _isCreatingAccount ? 'Creating Account...' : 'Create Account',
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