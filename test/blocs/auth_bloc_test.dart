import 'package:flutter_test/flutter_test.dart';

import 'package:kostasih_mobile/blocs/auth/auth_bloc.dart';
import 'package:kostasih_mobile/blocs/auth/auth_event.dart';
import 'package:kostasih_mobile/blocs/auth/auth_state.dart';
import 'package:kostasih_mobile/models/user_role.dart';
import 'package:kostasih_mobile/repositories/auth_repository.dart';

void main() {
  late AuthBloc bloc;

  setUp(() {
    bloc = AuthBloc(repository: DummyAuthRepository(latency: Duration.zero));
  });

  tearDown(() async {
    await bloc.close();
  });

  test('state awal adalah AuthInitial', () {
    expect(bloc.state, isA<AuthInitial>());
  });

  test('AuthStarted tanpa sesi tersimpan -> AuthUnauthenticated', () async {
    bloc.add(const AuthStarted());

    await expectLater(
      bloc.stream,
      emitsInOrder(<Matcher>[
        isA<AuthChecking>(),
        isA<AuthUnauthenticated>(),
      ]),
    );
  });

  test('login email @pemilik.test menghasilkan role pemilik', () async {
    bloc.add(
      const LoginSubmitted(
        email: 'gading@pemilik.test',
        password: 'password123',
      ),
    );

    final AuthState state = await bloc.stream.firstWhere(
      (AuthState s) => s is AuthAuthenticated,
    );

    expect(state, isA<AuthAuthenticated>());
    final AuthAuthenticated authenticated = state as AuthAuthenticated;
    expect(authenticated.user.role, UserRole.pemilik);
    expect(authenticated.user.isPemilik, isTrue);
  });

  test('login email biasa menghasilkan role penghuni', () async {
    bloc.add(
      const LoginSubmitted(
        email: 'bagus@penghuni.test',
        password: 'password123',
      ),
    );

    final AuthState state = await bloc.stream.firstWhere(
      (AuthState s) => s is AuthAuthenticated,
    );

    final AuthAuthenticated authenticated = state as AuthAuthenticated;
    expect(authenticated.user.role, UserRole.penghuni);
    expect(authenticated.user.namaKamar, isNotNull);
  });

  test('login dengan kata sandi pendek menghasilkan AuthError', () async {
    bloc.add(
      const LoginSubmitted(email: 'gading@mail.com', password: 'pendek'),
    );

    final AuthState state = await bloc.stream.firstWhere(
      (AuthState s) => s is AuthError,
    );

    expect((state as AuthError).message, 'Email atau kata sandi salah.');
  });

  test('register meneruskan role yang dipilih ke model', () async {
    bloc.add(
      const RegisterSubmitted(
        nama: 'Maulana Gading',
        email: 'gading@mail.com',
        password: 'password123',
        nomorWhatsapp: '081234567890',
        role: UserRole.pemilik,
      ),
    );

    final AuthState state = await bloc.stream.firstWhere(
      (AuthState s) => s is AuthAuthenticated,
    );

    final AuthAuthenticated authenticated = state as AuthAuthenticated;
    expect(authenticated.user.role, UserRole.pemilik);
    expect(authenticated.user.nama, 'Maulana Gading');
  });

  test('LoggedOut mengembalikan ke AuthUnauthenticated', () async {
    bloc.add(
      const LoginSubmitted(
        email: 'gading@pemilik.test',
        password: 'password123',
      ),
    );
    await bloc.stream.firstWhere((AuthState s) => s is AuthAuthenticated);

    bloc.add(const LoggedOut());

    final AuthState state = await bloc.stream.firstWhere(
      (AuthState s) => s is AuthUnauthenticated,
    );

    expect(state, isA<AuthUnauthenticated>());
  });
}
