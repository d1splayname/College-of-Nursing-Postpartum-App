import 'package:flutter/material.dart';

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