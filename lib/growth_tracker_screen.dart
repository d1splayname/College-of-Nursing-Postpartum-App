import 'package:flutter/material.dart';

class GrowthTrackerScreen extends StatefulWidget {
  final Color themeColor;
  
  const GrowthTrackerScreen({
    super.key,
    required this.themeColor,
  });

  @override
  State<GrowthTrackerScreen> createState() => _GrowthTrackerScreenState();
}

class _GrowthTrackerScreenState extends State<GrowthTrackerScreen> {
  int recoveryStage = 0;
  int completedTasks = 0;

  final List<String> plantEmojis = ['🌱', '🌿', '🪴', '🌳'];

  final List<String> stageLabels = [
    'Early Recovery',
    'Building Strength',
    'Gaining Confidence',
    'Thriving Mama',
  ];

  final List<String> stageMessages = [
    'You\'re in the early postpartum phase. Be gentle with yourself.',
    'You\'re building healthy routines. Keep going, mama!',
    'You\'re getting stronger every day. You\'re doing amazing!',
    'You\'re thriving! Look how far you\'ve come on this journey.',
  ];

  final List<String> weekLabels = [
    'Weeks 1-2',
    'Weeks 3-4',
    'Weeks 5-8',
    'Week 9+',
  ];

  void completeTask() {
    setState(() {
      completedTasks++;
      // Move to next stage every 5 completed tasks
      if (completedTasks >= 5 && recoveryStage < plantEmojis.length - 1) {
        recoveryStage++;
        completedTasks = 0;
        _showCelebration();
      }
    });
  }

  void _showCelebration() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '🎉 Stage Complete!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              plantEmojis[recoveryStage],
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              'You\'ve reached: ${stageLabels[recoveryStage]}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Continue',
              style: TextStyle(
                color: widget.themeColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (recoveryStage + 1) / plantEmojis.length;
    final int tasksNeeded = 5 - completedTasks;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recovery Journey 🌱',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: widget.themeColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Track your postpartum growth',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),

              // Plant Display Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.themeColor.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Plant emoji
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: widget.themeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        plantEmojis[recoveryStage],
                        style: const TextStyle(fontSize: 80),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Stage label
                    Text(
                      stageLabels[recoveryStage],
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Week label
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: widget.themeColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        weekLabels[recoveryStage],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: widget.themeColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Message
                    Text(
                      stageMessages[recoveryStage],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.themeColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Stage ${recoveryStage + 1} of ${plantEmojis.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Tasks to complete
              Text(
                'Complete Tasks to Grow',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.themeColor,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$completedTasks',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: widget.themeColor,
                          ),
                        ),
                        Text(
                          ' / 5',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tasksNeeded > 0
                          ? 'Complete $tasksNeeded more tasks to level up!'
                          : 'Ready to advance!',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: completeTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.themeColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Complete a Self-Care Task',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Tips section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.themeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: widget.themeColor),
                        const SizedBox(width: 10),
                        const Text(
                          'Ways to Grow',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTip('✓ Complete all daily self-care goals'),
                    _buildTip('✓ Log baby feeding and sleep'),
                    _buildTip('✓ Track your mood regularly'),
                    _buildTip('✓ Stay hydrated (8 glasses)'),
                    _buildTip('✓ Rest when baby sleeps'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, height: 1.5),
      ),
    );
  }
}