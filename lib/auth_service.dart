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

class AuthService {
  static const _apiBaseUrl = 'http://localhost:8080';
  static const _sessionCookieKey = 'session_cookie';
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

  Future<Map<String, String>> authenticatedHeaders() async {
    return {
      'Content-Type': 'application/json',
      ...await _sessionHeader(),
    };
  }
}
