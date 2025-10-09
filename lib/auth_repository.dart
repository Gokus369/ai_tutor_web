// A simple, swappable auth layer.
// Start with MockAuthRepository; later replace with your real implementation.

class UserAccount {
  final String id;
  final String email;
  final String displayName;
  UserAccount({required this.id, required this.email, required this.displayName});
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

// --- Fully working mock for local testing/demo ---
class MockAuthRepository implements AuthRepository {
  static const _demoEmail = 'demo@aitutor.app';
  static const _demoUser = 'demo';
  static const _demoPass = 'Passw0rd!';

  final List<_MockAccount> _accounts = [
    _MockAccount(
      id: 'u_001',
      email: _demoEmail,
      displayName: 'AiTutor Demo',
      password: _demoPass,
      username: _demoUser,
    ),
  ];

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
      throw Exception('Full name is required.');
    }
    if (_accounts.any((account) => account.email == normalisedEmail)) {
      throw Exception('An account with this email already exists.');
    }
    final idSuffix = (_accounts.length + 1).toString().padLeft(3, '0');
    final account = _MockAccount(
      id: 'u_$idSuffix',
      email: normalisedEmail,
      displayName: trimmedName,
      password: password,
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
    if (account != null && account.password == password) {
      return account.asUser();
    }
    throw Exception('Invalid credentials');
  }

  @override
  Future<UserAccount> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return UserAccount(id: 'g_123', email: 'google.user@example.com', displayName: 'Google User');
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate reset link sent
  }
}

class _MockAccount {
  _MockAccount({
    required this.id,
    required this.email,
    required this.displayName,
    required this.password,
    this.username,
    this.role,
    this.board,
    this.school,
  });

  final String id;
  final String email;
  final String displayName;
  final String password;
  final String? username;
  final String? role;
  final String? board;
  final String? school;

  bool matchesIdentifier(String identifier) =>
      identifier == email || (username != null && identifier == username);

  UserAccount asUser() => UserAccount(id: id, email: email, displayName: displayName);
}

/* -------------------------
   When you’re ready to wire real auth,
   create another class that implements AuthRepository,
   e.g., AuthRepositoryHttp or FirebaseAuthRepository,
   and pass that into MyApp(repository: YourRepo()).
-------------------------- */
