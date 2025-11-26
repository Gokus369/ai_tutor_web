import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

class UserAccount {
  final String id, email, displayName;
  UserAccount({required this.id, required this.email, required this.displayName});
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

class MockAuthRepository implements AuthRepository {
  final _authState = ValueNotifier<UserAccount?>(null);
  final _accounts = <_MockAccount>[_MockAccount(id: 'u_001', email: 'demo@aitutor.app', displayName: 'AiTutor Demo', passwordHash: _hash('password1'), username: 'demo')];

  @override ValueListenable<UserAccount?> get authState => _authState;
  @override UserAccount? get currentUser => _authState.value;

  @override Future<UserAccount> register({required String fullName, required String email, required String password, String? role, String? educationBoard, String? school}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (fullName.trim().isEmpty) throw const AuthValidationException('Name required');
    if (_accounts.any((a) => a.email == email.trim().toLowerCase())) throw const AuthDuplicateEmailException('Email exists');
    final u = _MockAccount(id: 'u_${(_accounts.length + 1).toString().padLeft(3, '0')}', email: email.trim().toLowerCase(), displayName: fullName.trim(), passwordHash: _hash(password), role: role, board: educationBoard, school: school);
    _accounts.add(u); return _authState.value = u.asUser();
  }

  @override Future<UserAccount> loginWithEmail(String id, String pw) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final a = _accounts.cast<_MockAccount?>().firstWhere((a) => a!.matches(id.trim().toLowerCase()), orElse: () => null);
    if (a != null && a.passwordHash == _hash(pw)) return _authState.value = a.asUser();
    throw const AuthInvalidCredentialsException();
  }

  @override Future<UserAccount> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _authState.value = UserAccount(id: 'g_123', email: 'google@example.com', displayName: 'Google User');
  }

  @override Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!_accounts.any((a) => a.matches(email))) throw const AuthValidationException('No account');
  }

  @override Future<void> logout() async => _authState.value = null;
  static String _hash(String p) => sha256.convert(utf8.encode('ai_tutor_demo_salt$p')).toString();
}

class _MockAccount {
  final String id, email, displayName, passwordHash;
  final String? username, role, board, school;
  _MockAccount({required this.id, required this.email, required this.displayName, required this.passwordHash, this.username, this.role, this.board, this.school});
  bool matches(String i) => i == email || (username != null && i == username);
  UserAccount asUser() => UserAccount(id: id, email: email, displayName: displayName);
}
