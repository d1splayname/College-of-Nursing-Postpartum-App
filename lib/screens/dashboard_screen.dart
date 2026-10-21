import 'package:flutter/material.dart';
import '../themes/app_themes.dart';
import 'package:google_fonts/google_fonts.dart'; // For text

// Dashboard Screen (Updated with personalization and theme color)
class DashboardScreen extends StatelessWidget {
  final String motherName;
  final String babyGender;
  final AppTheme theme;

  const DashboardScreen({
    super.key,
    required this.motherName,
    required this.babyGender,
    required this.theme,
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
              'Hello, $motherName',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: theme.white,
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
                    theme,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatCard(
                    'Last Sleep',
                    '3h ago',
                    Icons.bedtime,
                    theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            Text(
              'Today\'s Goals',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.black,
              ),
            ),
            const SizedBox(height: 15),

            // Self-care checklist
            _buildChecklistItem('Drink 8 glasses of water', true, theme),
            _buildChecklistItem('Take your vitamins', true, theme),
            _buildChecklistItem('Rest for 30 minutes', false, theme),
            _buildChecklistItem('Eat a healthy meal', false, theme),

            const Spacer(),

            // Encouragement card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.spa, color: theme.icon, size: 30),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      'Remember: Your well-being matters too',
                      style: GoogleFonts.poppins(
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

  Widget _buildStatCard(String label, String value, IconData icon, AppTheme theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.secondary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.icon, size: 35),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: theme.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text, bool checked, AppTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.circle_outlined,
            color: checked ? theme.card : theme.black,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16,
              decoration: checked ? TextDecoration.lineThrough : null,
              color: checked ? theme.card : theme.black,
            ),
          ),
        ],
      ),
    );
  }
}