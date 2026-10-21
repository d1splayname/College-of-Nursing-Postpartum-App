import 'package:flutter/material.dart';
import '../themes/app_themes.dart';
import 'package:google_fonts/google_fonts.dart'; // For text

// Dashboard Screen (Updated with personalization and theme color)
class DashboardScreen extends StatefulWidget {
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
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _goal1 = true;
  bool _goal2 = true;
  bool _goal3 = false;
  bool _goal4 = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: widget.theme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              // Spacer for top padding
              child: Text(
                'Hello, ${widget.motherName}',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: widget.theme.text,
                ),
              ),
            ),
            const SizedBox(height: 35),

            // Quick Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Last Feeding',
                    '2h ago',
                    Icons.restaurant,
                    widget.theme,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatCard(
                    'Last Sleep',
                    '3h ago',
                    Icons.bedtime,
                    widget.theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.theme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Goals',
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: widget.theme.text,
                    ),
                  ),
                  _buildChecklistItem(
                    'Drink 8 glasses of water',
                    _goal1,
                    widget.theme,
                    (val) => setState(() => _goal1 = val),
                  ),
                  _buildChecklistItem(
                    'Take your vitamins',
                    _goal2,
                    widget.theme,
                    (val) => setState(() => _goal2 = val),
                  ),
                  _buildChecklistItem(
                    'Rest for 30 minutes',
                    _goal3,
                    widget.theme,
                    (val) => setState(() => _goal3 = val),
                  ),
                  _buildChecklistItem(
                    'Eat a healthy meal',
                    _goal4,
                    widget.theme,
                    (val) => setState(() => _goal4 = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            const Spacer(),

            // Encouragement card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.theme.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.spa, color: widget.theme.icon, size: 30),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      'Remember: Your well-being matters too',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: widget.theme.icon,
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

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    AppTheme theme,
  ) {
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
          Icon(icon, color: theme.text, size: 35),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.text,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 12, color: theme.text),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(
    String text,
    bool checked,
    AppTheme theme,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => onChanged(!checked),
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
      ),
    );
  }
}
