import 'package:equatable/equatable.dart';

import '../../models/user_model.dart';

/// Status autentikasi aplikasi.
///
/// [AuthAuthenticated] menyimpan [UserModel] yang membawa `role`, sehingga UI
/// dapat mengarahkan pengguna ke dashboard yang sesuai.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Kondisi awal sebelum sesi diperiksa.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Sedang memeriksa sesi tersimpan.
class AuthChecking extends AuthState {
  const AuthChecking();
}

/// Belum login (menampilkan halaman Login).
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.message});

  /// Pesan opsional, mis. "Sesi berakhir, silakan masuk kembali."
  final String? message;

  @override
  List<Object?> get props => <Object?>[message];
}

/// Proses login/register sedang berjalan.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Login/register berhasil.
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final UserModel user;

  @override
  List<Object?> get props => <Object?>[user];
}

/// Login/register gagal.
class AuthError extends AuthState {
  const AuthError(this.message);

  /// Pesan siap ditampilkan lewat CustomSnackbar.
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
