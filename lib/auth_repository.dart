import 'dart:convert';
import 'package:ai_tutor_web/core/network/api_client.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class UserAccount {
  final String id, email, displayName;
  final String? accessToken, refreshToken, userType;
  UserAccount({
    required this.id,
    required this.email,
    required this.displayName,
    this.accessToken,
    this.refreshToken,
    this.userType,
  });
}

abstract class AuthRepository {
  Future<UserAccount> register({required String fullName, required String email, required String password, String? role, String? educationBoard, String? school});
  Future<UserAccount> loginWithEmail(String identifier, String password);
  Future<UserAccount> loginWithGoogle();
  Future<void> sendPasswordReset(String email);
  Future<void> logout();
  ValueListenable<UserAccount?> get authState;
  UserAccount? get currentUser;
}

class AuthException implements Exception { final String message; const AuthException(this.message); @override String toString() => message; }
class AuthValidationException extends AuthException { const AuthValidationException(super.message); }
class AuthDuplicateEmailException extends AuthValidationException { const AuthDuplicateEmailException(super.message); }
class AuthInvalidCredentialsException extends AuthException { const AuthInvalidCredentialsException([super.message = 'Invalid credentials']); }

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;
  final _authState = ValueNotifier<UserAccount?>(null);

  @override ValueListenable<UserAccount?> get authState => _authState;
  @override UserAccount? get currentUser => _authState.value;

  @override
  Future<UserAccount> loginWithEmail(String identifier, String password) async {
    final username = identifier.trim();
    if (username.isEmpty) throw const AuthValidationException('Username required');
    if (password.isEmpty) throw const AuthValidationException('Password required');

    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/login',
        data: {'username': username, 'password': password},
      );
      final data = response.data;
      if (data == null) throw const AuthException('Empty response');
      final status = data['statusCode'] as int? ?? response.statusCode ?? 500;
      if (status != 200) throw AuthException(data['message']?.toString() ?? 'Login failed ($status)');

      final token = (data['token'] as String?)?.trim();
      if (token == null || token.isEmpty) {
        throw const AuthException('Missing token in response');
      }
      final refresh = (data['refreshToken'] as String?)?.trim();
      _apiClient.dio.options.headers['Authorization'] = token;

      final user = UserAccount(
        id: data['id']?.toString() ?? username,
        email: data['email']?.toString() ?? '',
        displayName: data['name']?.toString().trim().isNotEmpty == true ? data['name'].toString() : username,
        accessToken: token,
        refreshToken: refresh,
        userType: data['userType']?.toString(),
      );
      _authState.value = user;
      return user;
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message']?.toString() ?? e.message)
          : e.message;
      throw AuthException(msg ?? 'Network error');
    }
  }

  @override
  Future<UserAccount> register({required String fullName, required String email, required String password, String? role, String? educationBoard, String? school}) async {
    final name = fullName.trim();
    final contactEmail = email.trim();
    final normalizedRole = role?.trim() ?? '';
    if (name.isEmpty) throw const AuthValidationException('Name required');
    if (contactEmail.isEmpty) throw const AuthValidationException('Email required');
    if (password.isEmpty) throw const AuthValidationException('Password required');

    final Map<String, dynamic> payload = {
      'name': name,
      'contactEmail': contactEmail,
      'password': password,
      // API allows multiple numbers; we default to none unless provided later in UI.
      'contactNumber': <String>[],
      'countryCode': '+91',
    };

    // Only SUPER_ADMIN is supported beyond the default (student). Map accordingly.
    if (normalizedRole.toLowerCase().contains('admin')) {
      payload['userType'] = 'SUPER_ADMIN';
    }

    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/users',
        data: payload,
      );
      final data = response.data;
      final status = response.statusCode ?? 500;
      if (status != 201 || data == null) {
        throw AuthException(data?['message']?.toString() ?? 'Signup failed ($status)');
      }

      return UserAccount(
        id: data['id']?.toString() ?? '',
        email: data['contactEmail']?.toString() ?? contactEmail,
        displayName: data['name']?.toString() ?? name,
        userType: data['userType']?.toString(),
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message']?.toString() ?? e.message)
          : e.message;
      throw AuthException(msg ?? 'Network error');
    }
  }

  @override
  Future<UserAccount> loginWithGoogle() async {
    throw const AuthException('Google login not supported in API');
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    throw const AuthException('Password reset not supported in API');
  }

  @override
  Future<void> logout() async {
    final refresh = _authState.value?.refreshToken;
    try {
      if (refresh != null && refresh.isNotEmpty) {
        await _apiClient.dio.post('/logout', data: {'refreshToken': refresh});
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode ?? 0;
      // If token already invalid/expired, still clear local session.
      if (status != 400 && status != 401) {
        final msg = e.response?.data is Map<String, dynamic>
            ? (e.response?.data['message']?.toString() ?? e.message)
            : e.message;
        throw AuthException(msg ?? 'Network error');
      }
    } finally {
      _apiClient.dio.options.headers.remove('Authorization');
      _authState.value = null;
    }
  }
}

class MockAuthRepository implements AuthRepository {
  final _authState = ValueNotifier<UserAccount?>(null);
  final _accounts = <_MockAccount>[_MockAccount(id: 'u_001', email: 'demo@aitutor.app', displayName: 'AiTutor Demo', passwordHash: _hash('password1'), username: 'demo')];

  @override ValueListenable<UserAccount?> get authState => _authState;
  @override UserAccount? get currentUser => _authState.value;

  bool hasAccount(String identifier) => _findAccount(identifier) != null;

  @override Future<UserAccount> register({required String fullName, required String email, required String password, String? role, String? educationBoard, String? school}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (fullName.trim().isEmpty) throw const AuthValidationException('Name required');
    if (_accounts.any((a) => a.email == email.trim().toLowerCase())) throw const AuthDuplicateEmailException('Email exists');
    final u = _MockAccount(id: 'u_${(_accounts.length + 1).toString().padLeft(3, '0')}', email: email.trim().toLowerCase(), displayName: fullName.trim(), passwordHash: _hash(password), role: role, board: educationBoard, school: school);
    _accounts.add(u); return _authState.value = u.asUser();
  }

  @override Future<UserAccount> loginWithEmail(String id, String pw) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final a = _findAccount(id);
    if (a != null && a.passwordHash == _hash(pw)) return _authState.value = a.asUser();
    throw const AuthInvalidCredentialsException();
  }

  @override Future<UserAccount> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _authState.value = UserAccount(id: 'g_123', email: 'google@example.com', displayName: 'Google User');
  }

  @override Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_findAccount(email) == null) throw const AuthValidationException('No account');
  }

  @override Future<void> logout() async => _authState.value = null;
  static String _hash(String p) => sha256.convert(utf8.encode('ai_tutor_demo_salt$p')).toString();

  _MockAccount? _findAccount(String identifier) {
    final id = identifier.trim().toLowerCase();
    return _accounts.cast<_MockAccount?>().firstWhere((a) => a!.matches(id), orElse: () => null);
  }
}

class _MockAccount {
  final String id, email, displayName, passwordHash;
  final String? username, role, board, school;
  _MockAccount({required this.id, required this.email, required this.displayName, required this.passwordHash, this.username, this.role, this.board, this.school});
  bool matches(String i) => i == email || (username != null && i == username);
  UserAccount asUser() => UserAccount(id: id, email: email, displayName: displayName);
}
