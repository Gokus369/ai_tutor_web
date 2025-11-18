import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

// A simple, swappable auth layer.
// Start with MockAuthRepository; later replace with your real implementation.

class UserAccount {
  final String id;
  final String email;
  final String displayName;
  UserAccount({
    required this.id,
    required this.email,
    required this.displayName,
  });
}

abstract class AuthRepository {
  Future<UserAccount> register({
    required String fullName,
    required String email,
    required String password,
    String? role,
    String? educationBoard,
    String? school,
  });
  Future<UserAccount> loginWithEmail(String identifier, String password);
  Future<UserAccount> loginWithGoogle();
  Future<void> sendPasswordReset(String email);
}

/// Base exception for all auth failures so the UI can map onto friendly errors.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => 'AuthException: $message';
}

/// Input validation issues (e.g. missing name, duplicate email).
class AuthValidationException extends AuthException {
  const AuthValidationException(super.message);
}

/// Specific validation error for duplicate accounts so the UI can highlight email field.
class AuthDuplicateEmailException extends AuthValidationException {
  const AuthDuplicateEmailException(super.message);
}

/// Authentication failures (e.g. wrong password).
class AuthInvalidCredentialsException extends AuthException {
  const AuthInvalidCredentialsException([
    super.message = 'Invalid credentials',
  ]);
}

// --- Fully working mock for local testing/demo ---
class MockAuthRepository implements AuthRepository {
  static const _demoEmail = 'demo@aitutor.app';
  static const _demoUser = 'demo';
  static const _demoPass = 'password1';
  static const _passwordSalt = 'ai_tutor_demo_salt';

  MockAuthRepository()
    : _accounts = [
        _MockAccount(
          id: 'u_001',
          email: _demoEmail,
          displayName: 'AiTutor Demo',
          passwordHash: _hashPassword(_demoPass),
          username: _demoUser,
        ),
      ];

  final List<_MockAccount> _accounts;

  @override
  Future<UserAccount> register({
    required String fullName,
    required String email,
    required String password,
    String? role,
    String? educationBoard,
    String? school,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final trimmedName = fullName.trim();
    final normalisedEmail = email.trim().toLowerCase();
    if (trimmedName.isEmpty) {
      throw const AuthValidationException('Full name is required.');
    }
    if (_accounts.any((account) => account.email == normalisedEmail)) {
      throw const AuthDuplicateEmailException(
        'An account with this email already exists.',
      );
    }
    final idSuffix = (_accounts.length + 1).toString().padLeft(3, '0');
    final account = _MockAccount(
      id: 'u_$idSuffix',
      email: normalisedEmail,
      displayName: trimmedName,
      passwordHash: _hashPassword(password),
      role: role,
      board: educationBoard,
      school: school,
    );
    _accounts.add(account);
    return account.asUser();
  }

  _MockAccount? _findAccount(String identifier) {
    final normalised = identifier.trim().toLowerCase();
    for (final account in _accounts) {
      if (account.matchesIdentifier(normalised)) {
        return account;
      }
    }
    return null;
  }

  @override
  Future<UserAccount> loginWithEmail(String identifier, String password) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final account = _findAccount(identifier);
    if (account != null && _passwordMatches(account, password)) {
      return account.asUser();
    }
    throw const AuthInvalidCredentialsException();
  }

  @override
  Future<UserAccount> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return UserAccount(
      id: 'g_123',
      email: 'google.user@example.com',
      displayName: 'Google User',
    );
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final account = _findAccount(email);
    if (account == null) {
      throw const AuthValidationException('No account found with that email.');
    }
    // Simulate reset link sent
  }

  static String _hashPassword(String password) {
    final salted = '$_passwordSalt$password';
    final bytes = utf8.encode(salted);
    return sha256.convert(bytes).toString();
  }

  bool _passwordMatches(_MockAccount account, String password) {
    return account.passwordHash == _hashPassword(password);
  }

  @visibleForTesting
  bool hasAccount(String identifier) => _findAccount(identifier) != null;
}

class _MockAccount {
  _MockAccount({
    required this.id,
    required this.email,
    required this.displayName,
    required this.passwordHash,
    this.username,
    this.role,
    this.board,
    this.school,
  });

  final String id;
  final String email;
  final String displayName;
  final String passwordHash;
  final String? username;
  final String? role;
  final String? board;
  final String? school;

  bool matchesIdentifier(String identifier) =>
      identifier == email || (username != null && identifier == username);

  UserAccount asUser() =>
      UserAccount(id: id, email: email, displayName: displayName);
}

/* -------------------------
   When you’re ready to wire real auth,
   create another class that implements AuthRepository,
   e.g., AuthRepositoryHttp or FirebaseAuthRepository,
   and pass that into MyApp(repository: YourRepo()).
-------------------------- */
