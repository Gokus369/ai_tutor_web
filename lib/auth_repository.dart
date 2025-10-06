// A simple, swappable auth layer.
// Start with MockAuthRepository; later replace with your real implementation.

class UserAccount {
  final String id;
  final String email;
  final String displayName;
  UserAccount({required this.id, required this.email, required this.displayName});
}

abstract class AuthRepository {
  Future<UserAccount> loginWithEmail(String identifier, String password);
  Future<UserAccount> loginWithGoogle();
  Future<void> sendPasswordReset(String email);
}

// --- Fully working mock for local testing/demo ---
class MockAuthRepository implements AuthRepository {
  static const _demoEmail = 'demo@aitutor.app';
  static const _demoUser = 'demo';
  static const _demoPass = 'Passw0rd!';

  @override
  Future<UserAccount> loginWithEmail(String identifier, String password) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final id = identifier.trim().toLowerCase();
    final okId = id == _demoEmail || id == _demoUser;
    if (okId && password == _demoPass) {
      return UserAccount(id: 'u_001', email: _demoEmail, displayName: 'AiTutor Demo');
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

/* -------------------------
   When you’re ready to wire real auth,
   create another class that implements AuthRepository,
   e.g., AuthRepositoryHttp or FirebaseAuthRepository,
   and pass that into MyApp(repository: YourRepo()).
-------------------------- */
