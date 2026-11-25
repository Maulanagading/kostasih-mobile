import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import '../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC yang mengatur alur autentikasi.
///
/// Pola wajib kontrak tim: Event -> Bloc -> State. UI tidak boleh memanggil
/// Repository secara langsung.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.repository}) : super(const AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<LoggedOut>(_onLoggedOut);
  }

  final AuthRepository repository;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(const AuthChecking());
    try {
      final UserModel? user = await repository.restoreSession();
      if (user == null) {
        emit(const AuthUnauthenticated());
      } else {
        emit(AuthAuthenticated(user));
      }
    } on AuthException catch (error) {
      emit(AuthUnauthenticated(message: error.message));
    }
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final UserModel user = await repository.login(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } on AuthException catch (error) {
      emit(AuthError(error.message));
    }
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final UserModel user = await repository.register(
        nama: event.nama,
        email: event.email,
        password: event.password,
        nomorWhatsapp: event.nomorWhatsapp,
        role: event.role,
        kamarId: event.kamarId,
      );
      emit(AuthAuthenticated(user));
    } on AuthException catch (error) {
      emit(AuthError(error.message));
    }
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await repository.logout();
    emit(const AuthUnauthenticated());
  }
}
