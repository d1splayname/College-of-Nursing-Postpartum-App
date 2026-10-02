import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../themes/app_themes.dart';

class FamilyScreen extends StatefulWidget {
  final AppTheme theme;

  const FamilyScreen({
    super.key,
    required this.theme,
  });

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  // Current family members
  final List<Map<String, String>> _familyMembers = [
    {
      'name': 'You',
      'relationship': 'Mom',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: theme.background,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: theme.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -----------------------------
                      // FAMILY MEMBERS CARD
                      // -----------------------------
                      _buildMembersCard(theme),

                      const SizedBox(height: 20),

                      // -----------------------------
                      // ADD FAMILY MEMBER CARD
                      // -----------------------------
                      _buildAddMemberCard(theme),
                    ],
                  ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
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

            ..._familyMembers.map(
              (member) => _buildMemberTile(
                member,
                theme,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INDIVIDUAL FAMILY MEMBER
  // ============================================================

  Widget _buildMemberTile(
    Map<String, String> member,
    AppTheme theme,
  ) {
    final bool isCurrentUser = member['name'] == 'You';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 4,
        ),

        leading: CircleAvatar(
          backgroundColor: theme.primary.withOpacity(0.15),
          child: Icon(
            isCurrentUser
                ? Icons.person
                : Icons.person_outline,
            color: theme.primary,
          ),
        ),

        title: Text(
          member['name']!,
          style: GoogleFonts.poppins(
            color: theme.icon,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Text(
          member['relationship']!,
          style: GoogleFonts.poppins(
            color: theme.icon.withOpacity(0.6),
            fontSize: 13,
          ),
        ),

        trailing: IconButton(
          icon: Icon(
            Icons.edit_outlined,
            color: theme.icon,
            size: 20,
          ),
          onPressed: () {
            _editMember(member, theme);
          },
        ),
      ),
    );
  }

  // ============================================================
  // ADD FAMILY MEMBER CARD
  // ============================================================

  Widget _buildAddMemberCard(AppTheme theme) {
    return Card(
      color: theme.primary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Family Member',
              style: GoogleFonts.poppins(
                color: theme.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Connect someone to your child\'s care team.',
              style: GoogleFonts.poppins(
                color: theme.black.withOpacity(0.65),
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 18),

            _buildAddOption(
              icon: Icons.person_add_outlined,
              title: 'Add Family Member',
              subtitle: 'Parent, grandparent, relative, or other caregiver',
              theme: theme,
              onTap: () {
                _addFamilyMember(theme);
              },
            ),

            const SizedBox(height: 10),

            _buildAddOption(
              icon: Icons.child_care_outlined,
              title: 'Add Caregiver',
              subtitle: 'Sitter, nanny, or another trusted caregiver',
              theme: theme,
              onTap: () {
                _addFamilyMember(
                  theme,
                  defaultRelationship: 'Sitter',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ADD OPTION
  // ============================================================

  Widget _buildAddOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required AppTheme theme,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.primary.withOpacity(0.15),
              child: Icon(
                icon,
                color: theme.primary,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: theme.icon,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: theme.icon.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: theme.icon,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ADD MEMBER
  // ============================================================

  void _addFamilyMember(
    AppTheme theme, {
    String? defaultRelationship,
  }) {
    final nameController = TextEditingController();

    String selectedRelationship =
        defaultRelationship ?? 'Parent';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: theme.primary,
              title: Text(
                'Add Family Member',
                style: GoogleFonts.poppins(
                  color: theme.black,
                  fontWeight: FontWeight.w600,
                ),
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    style: GoogleFonts.poppins(
                      color: theme.icon,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: GoogleFonts.poppins(
                        color: theme.black.withOpacity(0.7),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    value: selectedRelationship,
                    decoration: InputDecoration(
                      labelText: 'Relationship',
                      labelStyle: GoogleFonts.poppins(
                        color: theme.black.withOpacity(0.7),
                      ),
                    ),
                    items: [
                      'Mom',
                      'Dad',
                      'Grandma',
                      'Grandpa',
                      'Sibling',
                      'Aunt',
                      'Uncle',
                      'Sitter',
                      'Nanny',
                      'Other',
                    ].map((relationship) {
                      return DropdownMenuItem(
                        value: relationship,
                        child: Text(
                          relationship,
                          style: GoogleFonts.poppins(
                            color: theme.secondary,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedRelationship = value;
                        });
                      }
                    },
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      color: theme.icon,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      return;
                    }

                    setState(() {
                      _familyMembers.add({
                        'name': nameController.text.trim(),
                        'relationship': selectedRelationship,
                      });
                    });

                    Navigator.pop(context);
                  },
                  child: Text(
                    'Add',
                    style: GoogleFonts.poppins(
                      color: theme.primary,
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

  // ============================================================
  // EDIT MEMBER
  // ============================================================

  void _editMember(
    Map<String, String> member,
    AppTheme theme,
  ) {
    String selectedRelationship = member['relationship']!;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: theme.black,

              title: Text(
                member['name'] == 'You'
                    ? 'Edit Your Relationship'
                    : 'Edit Family Member',
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
                    color: theme.icon.withOpacity(0.7),
                  ),
                ),
                items: [
                  'Mom',
                  'Dad',
                  'Grandma',
                  'Grandpa',
                  'Sibling',
                  'Aunt',
                  'Uncle',
                  'Sitter',
                  'Nanny',
                  'Other',
                ].map((relationship) {
                  return DropdownMenuItem(
                    value: relationship,
                    child: Text(
                      relationship,
                      style: GoogleFonts.poppins(
                        color: theme.tertiary,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() {
                      selectedRelationship = value;
                    });
                  }
                },
              ),

              actions: [
                if (member['name'] != 'You')
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _familyMembers.remove(member);
                      });

                      Navigator.pop(context);
                    },
                    child: Text(
                      'Remove',
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                      ),
                    ),
                  ),

                TextButton(
                  onPressed: () {
                    setState(() {
                      member['relationship'] =
                          selectedRelationship;
                    });

                    Navigator.pop(context);
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