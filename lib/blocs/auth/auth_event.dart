import 'package:equatable/equatable.dart';

import '../../models/user_role.dart';

/// Aksi yang dapat dikirim ke [AuthBloc].
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Memeriksa sesi tersimpan saat aplikasi dibuka.
class AuthStarted extends AuthEvent {
  const AuthStarted();
}

/// Pengguna menekan tombol MASUK.
class LoginSubmitted extends AuthEvent {
  const LoginSubmitted({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => <Object?>[email, password];
}

/// Pengguna menekan tombol DAFTAR SEKARANG.
class RegisterSubmitted extends AuthEvent {
  const RegisterSubmitted({
    required this.nama,
    required this.email,
    required this.password,
    required this.nomorWhatsapp,
    required this.role,
    this.kamarId,
  });

  final String nama;
  final String email;
  final String password;
  final String nomorWhatsapp;
  final UserRole role;
  final int? kamarId;

  @override
  List<Object?> get props => <Object?>[
    nama,
    email,
    password,
    nomorWhatsapp,
    role,
    kamarId,
  ];
}

/// Pengguna menekan tombol keluar.
class LoggedOut extends AuthEvent {
  const LoggedOut();
}
