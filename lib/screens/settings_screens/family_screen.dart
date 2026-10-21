import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../themes/app_themes.dart';
import 'family_service.dart';


const List<String> kRelationships = [
  'Sitter',
  'Nanny',
  'Grandma',
  'Grandpa',
  'Sibling',
  'Aunt',
  'Uncle',
  'Mom',
  'Dad',
  'Other',
];

class FamilyScreen extends StatefulWidget {
  final AppTheme theme;
  final FamilyService? service;

  const FamilyScreen({
    super.key,
    required this.theme,
    this.service,
  });

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  // TODO(backend): change MockFamilyService() to ApiFamilyService()
  late final FamilyService _service = widget.service ?? MockFamilyService();

  List<FamilyMember> _members = [];
  bool _loading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final members = await _service.fetchMembers();
      if (!mounted) return;
      setState(() {
        _members = members;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = 'Could not load family members.';
        _loading = false;
      });
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: theme.background),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: theme.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                  child: _buildMembersCard(theme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FAMILY MEMBERS CARD 
  // ============================================================
  Widget _buildMembersCard(AppTheme theme) {
    return Card(
      color: theme.primary,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Family Members',
              style: GoogleFonts.poppins(
                color: theme.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Manage the people connected to your child.',
              style: GoogleFonts.poppins(
                color: theme.black.withOpacity(0.65),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 18),
            if (_loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_loadError != null)
              _buildLoadError(theme)
            else
              ..._members.map((m) => _buildMemberTile(m, theme)),
            const SizedBox(height: 8),
            _buildAddButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadError(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _loadError!,
          style: GoogleFonts.poppins(color: theme.black, fontSize: 13),
        ),
        TextButton(
          onPressed: _loadMembers,
          child: Text('Retry', style: GoogleFonts.poppins(color: theme.black)),
        ),
      ],
    );
  }

  // MEMBER TILE
  Widget _buildMemberTile(FamilyMember member, AppTheme theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: theme.tertiary.withOpacity(0.15),
          child: Icon(
            member.isCurrentUser ? Icons.person : Icons.person_outline,
            color: theme.black,
          ),
        ),
        title: Text(
          member.nickname,
          style: GoogleFonts.poppins(
            color: theme.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          member.relationship,
          style: GoogleFonts.poppins(
            color: theme.black.withOpacity(0.6),
            fontSize: 13,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit_outlined, color: theme.black, size: 20),
          onPressed: () => _editMember(member, theme),
        ),
      ),
    );
  }


  // SINGLE ADD BUTTON
  Widget _buildAddButton(AppTheme theme) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _addFamilyMember(theme),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.tertiary.withOpacity(0.15),
              child: Icon(Icons.person_add_outlined, color: theme.black),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add a Family Member',
                    style: GoogleFonts.poppins(
                      color: theme.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Babysitter, family member, or another trusted caregiver',
                    style: GoogleFonts.poppins(
                      color: theme.black.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: theme.black),
          ],
        ),
      ),
    );
  }

  // ADD MEMBER
  Future<void> _addFamilyMember(AppTheme theme) async {
    final added = await showDialog<FamilyMember>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AddMemberDialog(theme: theme, service: _service),
    );

    if (added != null && mounted) {
      setState(() => _members.add(added));
    }
  }


  // EDIT MEMBER
  void _editMember(FamilyMember member, AppTheme theme) {
    String selectedRelationship = member.relationship;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: theme.primary,
              title: Text(
                member.isCurrentUser
                    ? 'Edit Your Relationship'
                    : 'Edit ${member.nickname}',
                style: GoogleFonts.poppins(
                  color: theme.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: DropdownButtonFormField<String>(
                value: selectedRelationship,
                decoration: InputDecoration(
                  labelText: 'Relationship',
                  labelStyle: GoogleFonts.poppins(
                    color: theme.black.withOpacity(0.7),
                  ),
                ),
                items: kRelationships
                    .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(
                            r,
                            style: GoogleFonts.poppins(color: theme.black),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() => selectedRelationship = value);
                  }
                },
              ),
              actions: [
                if (!member.isCurrentUser)
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      try {
                        await _service.removeMember(member.id);
                        if (!mounted) return;
                        setState(() => _members.remove(member));
                      } catch (e) {
                        _showSnack('Could not remove member. Try again.');
                      }
                    },
                    child: Text(
                      'Remove',
                      style: GoogleFonts.poppins(color: Colors.red),
                    ),
                  ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    try {
                      await _service.updateRelationship(
                        member.id,
                        selectedRelationship,
                      );
                      if (!mounted) return;
                      setState(() => member.relationship = selectedRelationship);
                    } catch (e) {
                      _showSnack('Could not save changes. Try again.');
                    }
                  },
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(
                      color: theme.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}


// ADD MEMBER DIALOG
// username (unique), nickname (displayed in UI), password (+ relationship)
class _AddMemberDialog extends StatefulWidget {
  final AppTheme theme;
  final FamilyService service;

  const _AddMemberDialog({required this.theme, required this.service});

  @override
  State<_AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<_AddMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _relationship = 'Sitter';
  bool _obscurePassword = true;
  bool _submitting = false;
  String? _usernameError; // set when the server says the username is taken
  String? _generalError;

  @override
  void dispose() {
    _usernameController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _usernameError = null;
      _generalError = null;
    });
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      final member = await widget.service.addMember(
        username: _usernameController.text.trim(),
        nickname: _nicknameController.text.trim(),
        password: _passwordController.text,
        relationship: _relationship,
      );
      if (mounted) Navigator.pop(context, member);
    } on UsernameTakenException {
      setState(() {
        _usernameError = 'That username is already taken.';
        _submitting = false;
      });
      _formKey.currentState!.validate(); // re-run so the error shows
    } catch (e) {
      setState(() {
        _generalError = 'Something went wrong. Please try again.';
        _submitting = false;
      });
    }
  }

  InputDecoration _decoration(String label, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      suffixIcon: suffix,
      labelStyle: GoogleFonts.poppins(
        color: widget.theme.black.withOpacity(0.7),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final textStyle = GoogleFonts.poppins(color: theme.black);

    return AlertDialog(
      backgroundColor: theme.primary,
      title: Text(
        'Add a Family Member',
        style: GoogleFonts.poppins(
          color: theme.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _usernameController,
                style: textStyle,
                enabled: !_submitting,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                decoration: _decoration('Username'),
                onChanged: (_) {
                  if (_usernameError != null) {
                    setState(() => _usernameError = null);
                  }
                },
                validator: (value) {
                  if (_usernameError != null) return _usernameError;
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Enter a username';
                  if (v.length < 3) return 'At least 3 characters';
                  if (v.contains(' ')) return 'No spaces allowed';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nicknameController,
                style: textStyle,
                enabled: !_submitting,
                textInputAction: TextInputAction.next,
                decoration: _decoration('Nickname'),
                validator: (value) => (value?.trim().isEmpty ?? true)
                    ? 'Enter a nickname'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                style: textStyle,
                enabled: !_submitting,
                obscureText: _obscurePassword,
                decoration: _decoration(
                  'Password',
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: theme.black,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (value) {
                  if ((value ?? '').length < 8) {
                    return 'At least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _relationship,
                decoration: _decoration('Relationship'),
                items: kRelationships
                    .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(r, style: textStyle),
                        ))
                    .toList(),
                onChanged: _submitting
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _relationship = value);
                        }
                      },
              ),
              if (_generalError != null) ...[
                const SizedBox(height: 12),
                Text(
                  _generalError!,
                  style: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.pop(context),
          child: Text('Cancel', style: textStyle),
        ),
        TextButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  'Add',
                  style: GoogleFonts.poppins(
                    color: theme.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ],
    );
  }
}