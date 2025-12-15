import 'package:ai_tutor_web/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthStatus { initial, loading, authenticated, registered, error }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
  });

  final AuthStatus status;
  final UserAccount? user;
  final String? error;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    UserAccount? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<void> login(String username, String password) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      final user = await _repository.loginWithEmail(username, password);
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
      emit(state.copyWith(status: AuthStatus.initial));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthState(status: AuthStatus.initial, user: null));
  }

  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
    String? role,
    String? educationBoard,
    String? school,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      final user = await _repository.register(
        fullName: fullName,
        email: email,
        password: password,
        role: role ?? '',
        educationBoard: educationBoard ?? '',
        school: school ?? '',
      );
      emit(state.copyWith(status: AuthStatus.registered, user: user));
      emit(const AuthState(status: AuthStatus.initial));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
      emit(state.copyWith(status: AuthStatus.initial));
    }
  }
}
