import 'package:flutter/material.dart';

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