import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class AuthUser {
  final String username;

  const AuthUser({
    required this.username,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      username: json['username'] as String? ?? '',
    );
  }
}

class LoginResponse {
  final AuthUser user;
  final String token;

  const LoginResponse({
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: AuthUser.fromJson(json['user'] ?? {}),
      token: json['token'] as String? ?? '',
    );
  }
}

class SessionProfile {
  final String motherName;
  final String babyGender;
  final DateTime dueDate;
  final int themeColor;

  const SessionProfile({
    required this.motherName,
    required this.babyGender,
    required this.dueDate,
    required this.themeColor,
  });

  factory SessionProfile.fromJson(Map<String, dynamic> json) {
    return SessionProfile(
      motherName: json['motherName'] as String,
      babyGender: json['babyGender'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      themeColor: json['themeColor'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'motherName': motherName,
        'babyGender': babyGender,
        'dueDate': dueDate.toIso8601String(),
        'themeColor': themeColor,
      };
}

class StoredSession {
  final LoginResponse response;
  final SessionProfile? profile;

  const StoredSession({required this.response, this.profile});
}

class AuthService {
  static const _apiBaseUrl = 'http://localhost:8080';
  static const _sessionCookieKey = 'session_cookie';
  static const _profileKey = 'session_profile';
  static const _storage = FlutterSecureStorage();

  Future<LoginResponse> signup({
    required String name,
    required String username,
    required String password,
  }) async {
    final normalizedUsername = username.trim();
    if (normalizedUsername.isEmpty || password.isEmpty) {
      throw const ApiException('Username and password are required.');
    }
    return _authenticate(
      endpoint: '/api/signup',
      name: name.trim(),
      username: normalizedUsername,
      password: password,
      expectedStatus: 201,
      failureMessage: 'Account creation failed.',
    );
  }

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final normalizedUsername = username.trim();
    final normalizedPassword = password;

    if (normalizedUsername.isEmpty || normalizedPassword.isEmpty) {
      throw const ApiException('Username and password are required.');
    }

    return _authenticate(
      endpoint: '/api/login',
      username: normalizedUsername,
      password: normalizedPassword,
      expectedStatus: 200,
      failureMessage: 'Login failed.',
    );
  }

  Future<LoginResponse> _authenticate({
    required String endpoint,
    String? name,
    required String username,
    required String password,
    required int expectedStatus,
    required String failureMessage,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiBaseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          ...await _sessionHeader(),
        },
        body: jsonEncode({
          if (name != null) 'name': name,
          'username': username,
          'password': password,
        }),
      );
      if (response.statusCode != expectedStatus) {
        throw ApiException(
          response.body.isNotEmpty ? response.body : failureMessage,
        );
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final result = LoginResponse.fromJson(decoded);
      await _storage.write(key: _sessionCookieKey, value: 'session=${result.token}');
      return result;
    } on http.ClientException {
      throw const ApiException(
        'Could not reach the server. Check that the backend is running.',
      );
    }
  }

  Future<Map<String, String>> _sessionHeader() async {
    final cookie = await _storage.read(key: _sessionCookieKey);
    return cookie == null ? {} : {'Cookie': cookie};
  }

  Future<void> logout() => _storage.delete(key: _sessionCookieKey);

  Future<void> saveProfile(SessionProfile profile) async {
    await _storage.write(
      key: _profileKey,
      value: jsonEncode(profile.toJson()),
    );
  }

  Future<StoredSession?> restoreSession() async {
    final token = await _storage.read(key: _sessionCookieKey);
    if (token == null || token.isEmpty) return null;

    try {
      final response = await http.get(
        Uri.parse('$_apiBaseUrl/api/session'),
        headers: {
          ...await _sessionHeader(),
          'Authorization': 'Bearer ${token.replaceFirst('session=', '')}',
        },
      );
      if (response.statusCode != 200) {
        await logout();
        return null;
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final profileJson = await _storage.read(key: _profileKey);
      return StoredSession(
        response: LoginResponse(
          token: token.replaceFirst('session=', ''),
          user: AuthUser.fromJson(decoded['user'] as Map<String, dynamic>),
        ),
        profile: profileJson == null
            ? null
            : SessionProfile.fromJson(
                jsonDecode(profileJson) as Map<String, dynamic>,
              ),
      );
    } on FormatException {
      await logout();
      return null;
    } on http.ClientException {
      return null;
    }
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _sessionCookieKey);
    await _storage.delete(key: _profileKey);
  }

  Future<Map<String, String>> authenticatedHeaders() async {
    return {
      'Content-Type': 'application/json',
      ...await _sessionHeader(),
    };
  }
}
