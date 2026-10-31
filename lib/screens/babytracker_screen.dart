import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../themes/app_themes.dart';

import '../auth_service.dart';
import '../calendar_service.dart';

// Baby Tracker Screen (Updated with gender and theme color)
class BabyTrackerScreen extends StatefulWidget {
  final String babyGender;
  final List<ChildProfile> children;
  final AppTheme theme;

  const BabyTrackerScreen({
    super.key,
    required this.babyGender,
    this.children = const [],
    required this.theme,
  });

  @override
  State<BabyTrackerScreen> createState() => _BabyTrackerScreenState();
}

class _BabyTrackerScreenState extends State<BabyTrackerScreen> {
  final CalendarService _calendarService = CalendarService();
  List<Map<String, dynamic>> activities = [];
  bool _isLoggingActivity = false;
  int _selectedActivityBaby = -1;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    try {
      final events = await _calendarService.fetchEvents();
      final trackerEvents = events
          .where((event) => event.eventType == 'activity' && event.description.contains('from Baby Tracker'))
          .toList()
        ..sort((a, b) => b.startTime.compareTo(a.startTime));

      if (!mounted) return;

      setState(() {
        activities = trackerEvents.map((event) {
          final match = RegExp(r'^Baby (\d+) (.+)$').firstMatch(event.title);
          final oldMatch = RegExp(r'^Baby (.+)$').firstMatch(event.title);
          final babyIndex = match == null ? 0 : int.parse(match.group(1)!) - 1;
          final type = match?.group(2) ?? oldMatch?.group(1) ?? event.title;

          return <String, dynamic>{
            'type': type,
            'time': _formatTime(event.startTime),
            'babyIndex': babyIndex,
            'icon': _iconForActivity(type),
            'color': _colorForActivity(type),
          };
        }).toList();
      });
    } on ApiException {
      // Leave Recent Activity empty if saved events cannot be loaded.
    }
  }

  String _formatTime(DateTime time) {
    final difference = DateTime.now().difference(time);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} minutes ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    return '${difference.inDays} days ago';
  }

  IconData _iconForActivity(String type) {
    if (type == 'Feeding') return Icons.restaurant;
    if (type == 'Diaper') return Icons.child_care;
    return Icons.bedtime;
  }

  Color _colorForActivity(String type) {
    if (type == 'Feeding') return widget.theme.card;
    if (type == 'Diaper') return widget.theme.card.withValues(alpha: 0.7);
    return widget.theme.card.withValues(alpha: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    final visibleActivities = _selectedActivityBaby == -1
        ? activities
        : activities.where((activity) => activity['babyIndex'] == _selectedActivityBaby).toList();

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
              child: Text(
                'Baby Tracker',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: widget.theme.text,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Take care of your little one.',
              style: TextStyle(fontSize: 20, color: widget.theme.text),
            ),
            const SizedBox(height: 30),

            // Quick Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  'Feed',
                  Icons.restaurant,
                  widget.theme.text,
                  () => _selectChildAndAddActivity('Feeding', Icons.restaurant),
                ),
                _buildActionButton(
                  'Diaper',
                  Icons.child_care,
                  widget.theme.text,
                  () => _selectChildAndAddActivity('Diaper', Icons.child_care),
                ),
                _buildActionButton(
                  'Sleep',
                  Icons.bedtime,
                  widget.theme.text,
                  () => _selectChildAndAddActivity('Sleep', Icons.bedtime),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (widget.children.length > 1) ...[
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildActivityTab('All', -1),
                    ...List.generate(
                      widget.children.length,
                      (index) => _buildActivityTab('Baby ${index + 1}', index),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 15),

            // Activity List
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),

                itemCount: visibleActivities.length,
                itemBuilder: (context, index) {
                  final activity = visibleActivities[index];
                  final babyIndex = activity['babyIndex'] as int;
                  final baby = widget.children.length > 1 ? 'Baby ${babyIndex + 1}' : 'Baby';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: widget.theme.primary,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: (activity['color'] as Color).withValues(
                            alpha: 0.2,
                          ),
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
                            color: (activity['color'] as Color).withValues(
                              alpha: 0.3,
                            ),
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
                                '$baby • ${activity['time']}',
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

  Widget _buildActivityTab(String label, int babyIndex) {
    final isSelected = _selectedActivityBaby == babyIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedActivityBaby = babyIndex;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? widget.theme.card : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: widget.theme.card),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? widget.theme.black : widget.theme.text,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: widget.theme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: widget.theme.text.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: _isLoggingActivity ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, color: color, size: 35),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.theme.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectChildAndAddActivity(String type, IconData icon) async {
    if (widget.children.length <= 1) {
      await _addActivity(type, icon, 0);
      return;
    }

    final childIndex = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Which baby?', style: TextStyle(color: widget.theme.text)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.children.length, (index) {
              return ListTile(
                leading: Icon(Icons.child_care, color: widget.theme.primary),
                title: Text('Baby ${index + 1}'),
                subtitle: Text('Gender: ${widget.children[index].gender}'),
                onTap: () => Navigator.pop(context, index),
              );
            }),
          ),
        );
      },
    );

    if (childIndex != null) {
      await _addActivity(type, icon, childIndex);
    }
  }

  Future<void> _addActivity(String type, IconData icon, int childIndex) async {
    if (_isLoggingActivity) return;

    setState(() {
      _isLoggingActivity = true;
    });

    final child = 'Baby ${childIndex + 1}';

    try {
      final event = await _calendarService.logActivity(
        title: '$child $type',
        description: '$type recorded for $child from Baby Tracker',
      );

      if (!mounted) return;

      setState(() {
        _selectedActivityBaby = widget.children.length > 1 ? childIndex : -1;
        activities.insert(0, <String, dynamic>{
          'type': type,
          'time': _formatTime(event.startTime),
          'babyIndex': childIndex,
          'icon': icon,
          'color': widget.theme.card,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$type logged for ${widget.children.length > 1 ? child : 'Baby'}!'),
          backgroundColor: widget.theme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } on http.ClientException {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not reach the server. $type was not added to Recent Activity.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingActivity = false;
        });
      }
    }
  }
}