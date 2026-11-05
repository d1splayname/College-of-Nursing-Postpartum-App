import 'package:flutter/material.dart';
import '../themes/app_themes.dart';
import '../auth_service.dart';
import '../calendar_service.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:async';
import 'dart:ui' show FontFeature;

class BabyTrackerScreen extends StatefulWidget {
  final String babyGender;
  final AppTheme theme;

  const BabyTrackerScreen({
    super.key,
    required this.babyGender,
    required this.theme,
  });

  @override
  State<BabyTrackerScreen> createState() => _BabyTrackerScreenState();
}



// Models
class FeedingEntry {
  DateTime time;
  double ounces;

  FeedingEntry({required this.time, required this.ounces});
}

class DiaperEntry {
  DateTime time;
  String type; // Wet, Dirty, Both

  DiaperEntry({required this.time, required this.type});
}

class NapEntry {
  DateTime time;
  Duration duration;

  NapEntry({required this.time, required this.duration});

  DateTime get start => time.subtract(duration);
}





// Helpers
String _formatTime(DateTime time) {
  final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}

String _formatDateTime(DateTime time) {
  final now = DateTime.now();
  final isToday =
      time.year == now.year && time.month == now.month && time.day == now.day;

  if (isToday) return 'Today, ${_formatTime(time)}';

  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[time.month - 1]} ${time.day}, ${_formatTime(time)}';
}

String _formatDuration(Duration duration) {
  final totalMinutes = duration.inMinutes;
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;

  if (hours == 0) return '$minutes min';
  if (minutes == 0) return '$hours hr';
  return '$hours hr $minutes min';
}

String _formatElapsed(Duration d) {
  final h = d.inHours.toString().padLeft(2, '0');
  final m = (d.inMinutes % 60).toString().padLeft(2, '0');
  final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  return '$h:$m:$s';
}

String _formatOunces(double value) {
  return value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();
}

Future<DateTime?> _pickTime(BuildContext context, DateTime initial) async {
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial),
  );

  if (time == null) return null;

  return DateTime(initial.year, initial.month, initial.day, time.hour, time.minute);
}





// State
class _BabyTrackerScreenState extends State<BabyTrackerScreen> {
  final CalendarService _calendarService = CalendarService();

  final List<FeedingEntry> _feedings = [];
  final List<DiaperEntry> _diapers = [];
  final List<NapEntry> _naps = [];

  DateTime? _napStart;
  Timer? _ticker;

  bool get _napping => _napStart != null;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  // Shortcut to the app theme passed into this screen.
  AppTheme get _t => widget.theme;

  void _sortAll() {
    _feedings.sort((a, b) => b.time.compareTo(a.time));
    _diapers.sort((a, b) => b.time.compareTo(a.time));
    _naps.sort((a, b) => b.time.compareTo(a.time));
  }

  Future<void> _logCalendarActivity(String title, String description) async {
    try {
      await _calendarService.logActivity(
        title: title,
        description: description,
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (_) {
      // Keep the local tracker usable if calendar logging fails.
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'The tracker entry was saved on this screen, '
            'but calendar logging failed.',
          ),
        ),
      );
    }
  }

  Future<bool> _confirmDelete(String label) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete entry?'),
        content: Text('Remove this $label entry permanently from the log?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Delete', style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  // ----- FEEDING -----

  Future<void> _addFeeding() async {
    final result = await showDialog<FeedingEntry>(
      context: context,
      builder: (_) => const _FeedingDialog(),
    );

    if (result == null || !mounted) return;

    setState(() {
      _feedings.add(result);
      _sortAll();
    });

    await _logCalendarActivity(
      'Baby Feeding',
      '${_formatOunces(result.ounces)} oz recorded at '
          '${_formatTime(result.time)}',
    );
  }

  Future<void> _editFeeding(FeedingEntry entry) async {
    final result = await showDialog<FeedingEntry>(
      context: context,
      builder: (_) => _FeedingDialog(existing: entry),
    );

    if (result == null || !mounted) return;

    setState(() {
      entry.ounces = result.ounces;
      entry.time = result.time;
      _sortAll();
    });
  }

  Future<void> _deleteFeeding(FeedingEntry entry) async {
    if (!await _confirmDelete('feeding') || !mounted) return;
    setState(() => _feedings.remove(entry));
  }

  // ----- DIAPERS -----

  Future<void> _addDiaper() async {
    final result = await showDialog<DiaperEntry>(
      context: context,
      builder: (_) => const _DiaperDialog(),
    );

    if (result == null || !mounted) return;

    setState(() {
      _diapers.add(result);
      _sortAll();
    });

    await _logCalendarActivity(
      'Baby Diaper',
      '${result.type} diaper recorded at ${_formatTime(result.time)}',
    );
  }

  Future<void> _editDiaper(DiaperEntry entry) async {
    final result = await showDialog<DiaperEntry>(
      context: context,
      builder: (_) => _DiaperDialog(existing: entry),
    );

    if (result == null || !mounted) return;

    setState(() {
      entry.type = result.type;
      entry.time = result.time;
      _sortAll();
    });
  }

  Future<void> _deleteDiaper(DiaperEntry entry) async {
    if (!await _confirmDelete('diaper') || !mounted) return;
    setState(() => _diapers.remove(entry));
  }

  // ----- NAPS -----

  Future<void> _onNapPressed() async {
    if (_napping) {
      await _endNap();
      return;
    }

    final choice = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Log a nap'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(dialogContext, 'timer'),
            child: const ListTile(
              leading: Icon(Icons.timer),
              title: Text('Start nap timer'),
              subtitle: Text('Baby is falling asleep now'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(dialogContext, 'manual'),
            child: const ListTile(
              leading: Icon(Icons.edit_calendar),
              title: Text('Enter length manually'),
              subtitle: Text('Log a nap that already happened'),
            ),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (choice == 'timer') {
      await _startNap();
    } else if (choice == 'manual') {
      await _addNap();
    }
  }

  Future<void> _startNap() async {
    final now = DateTime.now();

    setState(() => _napStart = now);
    _startTicker();

    await _logCalendarActivity(
      'Baby Nap Started',
      'Nap started at ${_formatTime(now)}',
    );
  }

  Future<void> _endNap() async {
    final start = _napStart;
    if (start == null) return;

    final now = DateTime.now();
    final duration = now.difference(start);

    _stopTicker();

    setState(() {
      _napStart = null;
      _naps.add(NapEntry(time: now, duration: duration));
      _sortAll();
    });

    await _logCalendarActivity(
      'Baby Nap Ended',
      'Nap from ${_formatTime(start)} to ${_formatTime(now)}; '
          'duration ${_formatDuration(duration)}',
    );
  }

  Future<void> _cancelNapTimer() async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Discard nap timer?'),
        content: const Text('The running timer will be stopped and not saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep timing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Discard', style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );

    if (discard != true || !mounted) return;

    _stopTicker();
    setState(() => _napStart = null);
  }

  Future<void> _addNap() async {
    final result = await showDialog<NapEntry>(
      context: context,
      builder: (_) => const _NapDialog(),
    );

    if (result == null || !mounted) return;

    setState(() {
      _naps.add(result);
      _sortAll();
    });

    await _logCalendarActivity(
      'Baby Nap',
      'Nap from ${_formatTime(result.start)} to ${_formatTime(result.time)}; '
          'duration ${_formatDuration(result.duration)}',
    );
  }

  Future<void> _editNap(NapEntry entry) async {
    final result = await showDialog<NapEntry>(
      context: context,
      builder: (_) => _NapDialog(existing: entry),
    );

    if (result == null || !mounted) return;

    setState(() {
      entry.duration = result.duration;
      entry.time = result.time;
      _sortAll();
    });
  }

  Future<void> _deleteNap(NapEntry entry) async {
    if (!await _confirmDelete('nap') || !mounted) return;
    setState(() => _naps.remove(entry));
  }





// Page Layout
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Care Log',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: _t.black,
            ),
          ),
          const SizedBox(height: 60),

          // (1) Log buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLogButton('Food', Icons.restaurant, _addFeeding),
              _buildLogButton('Diaper', Icons.child_care, _addDiaper),
              _buildLogButton(
                'Nap',
                Icons.bedtime,
                _onNapPressed,
                active: _napping,
              ),
            ],
          ),

          if (_napping) ...[
            const SizedBox(height: 12),
            _buildNapBanner(),
          ],

          const SizedBox(height: 24),

          // (2) Three separate log containers
          _buildLogContainer(
            title: 'Food Log',
            icon: Icons.restaurant,
            color: _t.text,
            emptyMessage: 'No feedings recorded yet.',
            children: _feedings
                .map(
                  (e) => _buildEntryTile(
                    icon: Icons.restaurant,
                    color: _t.text,
                    title: '${_formatOunces(e.ounces)} oz',
                    subtitle: _formatDateTime(e.time),
                    onEdit: () => _editFeeding(e),
                    onDelete: () => _deleteFeeding(e),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),

          _buildLogContainer(
            title: 'Diaper Log',
            icon: Icons.child_care,
            color: _t.text,
            emptyMessage: 'No diaper changes recorded yet.',
            children: _diapers
                .map(
                  (e) => _buildEntryTile(
                    icon: Icons.child_care,
                    color: _t.text,
                    title: '${e.type} diaper',
                    subtitle: _formatDateTime(e.time),
                    onEdit: () => _editDiaper(e),
                    onDelete: () => _deleteDiaper(e),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),

          _buildLogContainer(
            title: 'Nap Log',
            icon: Icons.bedtime,
            color: _t.text,
            emptyMessage: 'No naps recorded yet.',
            children: _naps
                .map(
                  (e) => _buildEntryTile(
                    icon: Icons.bedtime,
                    color: _t.text,
                    title: _formatDuration(e.duration),
                    subtitle: '${_formatTime(e.start)} – '
                        '${_formatDateTime(e.time)}',
                    onEdit: () => _editNap(e),
                    onDelete: () => _deleteNap(e),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
         // Encouragement card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _t.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.spa, color: _t.icon, size: 30),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    'Remember: Your well-being matters too',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _t.icon,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLogButton(
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool active = false,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: active ? _t.primary : _t.secondary,
        foregroundColor: active ? _t.card : _t.text,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: _t.secondary.withValues(alpha: 0.25)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            active ? 'End $label' : 'Log $label',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Icon(icon, size: 24),
        ],
      ),
    );
  }

  Widget _buildNapBanner() {
    final start = _napStart!;
    final elapsed = DateTime.now().difference(start);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: _t.text.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.bedtime, color: _t.text),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Baby is sleeping since ${_formatTime(start)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: _t.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatElapsed(elapsed),
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    color: _t.text,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _cancelNapTimer,
            child: Text('Discard', style: GoogleFonts.poppins(color: _t.text)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: _t.text,
              foregroundColor: _t.primary,
            ),
            onPressed: _endNap,
            child: const Text('End nap'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogContainer({
    required String title,
    required IconData icon,
    required Color color,
    required String emptyMessage,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _t.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _t.text,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${children.length})',
                style: GoogleFonts.poppins(color: _t.text.withValues(alpha: 0.65)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (children.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                emptyMessage,
                style: GoogleFonts.poppins(
                  color: _t.text.withValues(alpha: 0.65),
                  fontSize: 13,
                ),
              ),
            )
          else
            ...children,
        ],
      ),
    );
  }

// **************
// Future Work: Make tile color theme consistent
// **************
  Widget _buildEntryTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: _t.text.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: _t.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: _t.text.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit',
            icon: Icon(Icons.edit, size: 20, color: _t.text),
            onPressed: onEdit,
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}


// Dialogs
class _FeedingDialog extends StatefulWidget {
  final FeedingEntry? existing;

  const _FeedingDialog({this.existing});

  @override
  State<_FeedingDialog> createState() => _FeedingDialogState();
}

class _FeedingDialogState extends State<_FeedingDialog> {
  late final TextEditingController _controller;
  late DateTime _time;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _controller = TextEditingController(
      text: e == null ? '' : _formatOunces(e.ounces),
    );
    _time = e?.time ?? DateTime.now();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final amount = double.tryParse(_controller.text.trim());

    if (amount == null || !amount.isFinite || amount <= 0) {
      setState(() => _error = 'Enter an amount greater than 0');
      return;
    }

    Navigator.pop(context, FeedingEntry(time: _time, ounces: amount));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Record feeding' : 'Edit feeding'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Amount consumed',
              suffixText: 'oz',
              hintText: 'e.g. 4.5',
              errorText: _error,
            ),
          ),
          const SizedBox(height: 24),
          Text('Time: ${_formatDateTime(_time)}'),
          TextButton.icon(
            onPressed: () async {
              final picked = await _pickTime(context, _time);
              if (picked != null && mounted) setState(() => _time = picked);
            },
            icon: const Icon(Icons.schedule),
            label: const Text('Change time'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}

class _DiaperDialog extends StatefulWidget {
  final DiaperEntry? existing;

  const _DiaperDialog({this.existing});

  @override
  State<_DiaperDialog> createState() => _DiaperDialogState();
}

class _DiaperDialogState extends State<_DiaperDialog> {
  static const _types = ['Wet', 'Dirty', 'Both'];

  late String _type;
  late DateTime _time;

  @override
  void initState() {
    super.initState();
    _type = widget.existing?.type ?? _types.first;
    _time = widget.existing?.time ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.existing == null ? 'Record diaper change' : 'Edit diaper entry',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Diaper type'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _types.map((type) {
              return ChoiceChip(
                label: Text(type),
                selected: _type == type,
                onSelected: (_) => setState(() => _type = type),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text('Time: ${_formatDateTime(_time)}'),
          TextButton.icon(
            onPressed: () async {
              final picked = await _pickTime(context, _time);
              if (picked != null && mounted) setState(() => _time = picked);
            },
            icon: const Icon(Icons.schedule),
            label: const Text('Change time'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.pop(context, DiaperEntry(time: _time, type: _type)),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _NapDialog extends StatefulWidget {
  final NapEntry? existing;

  const _NapDialog({this.existing});

  @override
  State<_NapDialog> createState() => _NapDialogState();
}

class _NapDialogState extends State<_NapDialog> {
  late final TextEditingController _hours;
  late final TextEditingController _minutes;
  late DateTime _wakeTime;
  String? _error;

  @override
  void initState() {
    super.initState();
    final d = widget.existing?.duration;
    _hours = TextEditingController(
      text: d == null ? '' : (d.inMinutes ~/ 60).toString(),
    );
    _minutes = TextEditingController(
      text: d == null ? '' : (d.inMinutes % 60).toString(),
    );
    _wakeTime = widget.existing?.time ?? DateTime.now();
  }

  @override
  void dispose() {
    _hours.dispose();
    _minutes.dispose();
    super.dispose();
  }

  void _save() {
    final h = _hours.text.trim().isEmpty ? 0 : int.tryParse(_hours.text.trim());
    final m =
        _minutes.text.trim().isEmpty ? 0 : int.tryParse(_minutes.text.trim());

    if (h == null || m == null || h < 0 || m < 0) {
      setState(() => _error = 'Enter whole numbers only');
      return;
    }

    final duration = Duration(hours: h, minutes: m);

    if (duration.inMinutes <= 0) {
      setState(() => _error = 'Nap length must be greater than 0');
      return;
    }

    Navigator.pop(context, NapEntry(time: _wakeTime, duration: duration));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Record nap' : 'Edit nap'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Length of nap'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _hours,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Hours',
                    hintText: '0',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _minutes,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Minutes',
                    hintText: '30',
                  ),
                ),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
            ),
          ],
          const SizedBox(height: 24),
          Text('Woke up: ${_formatDateTime(_wakeTime)}'),
          TextButton.icon(
            onPressed: () async {
              final picked = await _pickTime(context, _wakeTime);
              if (picked != null && mounted) {
                setState(() => _wakeTime = picked);
              }
            },
            icon: const Icon(Icons.schedule),
            label: const Text('Change time'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}