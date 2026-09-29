import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<StoredSession?> _session;

  @override
  void initState() {
    super.initState();
    _session = AuthService().restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StoredSession?>(
      future: _session,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data;
        if (session == null) return const LoginScreen();

        final profile = session.profile;
        return HomeScreen(
          motherName: profile?.motherName ?? session.response.user.username,
          babyGender: profile?.babyGender ?? 'Neutral',
          dueDate: profile?.dueDate ?? DateTime.now(),
          themeColor: profile == null
              ? const Color(0xFF9C88D9)
              : Color(profile.themeColor),
        );
      },
    );
  }
}
