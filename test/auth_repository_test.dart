import 'package:ai_tutor_web/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MockAuthRepository', () {
    late MockAuthRepository repository;

    setUp(() {
      repository = MockAuthRepository();
    });

    test(
      'register trims inputs and allows login with hashed password',
      () async {
        final user = await repository.register(
          fullName: '  Rowan Teacher ',
          email: 'NEW@MAIL.com ',
          password: 'Secret123!',
        );

        expect(user.displayName, 'Rowan Teacher');
        expect(user.email, 'new@mail.com');
        expect(repository.hasAccount('new@mail.com'), isTrue);

        final loginUser = await repository.loginWithEmail(
          'new@mail.com',
          'Secret123!',
        );
        expect(loginUser.id, user.id);

        await expectLater(
          repository.loginWithEmail('new@mail.com', 'wrong'),
          throwsA(isA<AuthInvalidCredentialsException>()),
        );
      },
    );

    test('register rejects duplicate emails and missing names', () async {
      await expectLater(
        repository.register(
          fullName: 'Demo User',
          email: 'demo@aitutor.app',
          password: 'password1',
        ),
        throwsA(isA<AuthDuplicateEmailException>()),
      );

      await expectLater(
        repository.register(
          fullName: '   ',
          email: 'unique@example.com',
          password: 'password1',
        ),
        throwsA(isA<AuthValidationException>()),
      );
    });

    test('_findAccount recognises username and email', () {
      expect(repository.hasAccount('demo@aitutor.app'), isTrue);
      expect(repository.hasAccount('demo'), isTrue);
      expect(repository.hasAccount('missing'), isFalse);
    });

    test('sendPasswordReset validates email existence', () async {
      await repository.sendPasswordReset('demo@aitutor.app');

      await expectLater(
        repository.sendPasswordReset('unknown@example.com'),
        throwsA(isA<AuthValidationException>()),
      );
    });
  });
}
