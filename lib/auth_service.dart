import 'dart:convert';
import 'package:http/http.dart' as http;

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
  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final normalizedUsername = username.trim();
    final normalizedPassword = password.trim();

    if (normalizedUsername.isEmpty || normalizedPassword.isEmpty) {
      throw const ApiException('Username and password are required.');
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': normalizedUsername,
          'password': normalizedPassword,
        }),
      );

      if (response.statusCode != 200) {
        throw ApiException(
          response.body.isNotEmpty ? response.body : 'Login failed.',
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return LoginResponse.fromJson(decoded);
    } on http.ClientException {
      throw const ApiException(
        'Could not reach the login server. Check that the backend is running and CORS is enabled.',
      );
    }
  }
}
