import 'package:flutter/material.dart';

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