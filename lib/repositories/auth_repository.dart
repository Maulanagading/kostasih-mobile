import '../models/user_model.dart';
import '../models/user_role.dart';

/// Kegagalan bisnis dari lapisan Repository.
///
/// Seluruh error (jaringan, validasi server, kredensial salah) dipetakan ke
/// tipe ini agar BLoC dapat menampilkan pesan yang ramah pengguna.
class AuthException implements Exception {
  const AuthException(this.message, {this.code});

  /// Pesan siap tampil ke pengguna.
  final String message;

  /// Kode teknis opsional untuk logging.
  final String? code;

  @override
  String toString() => 'AuthException($code): $message';
}

/// Kontrak akses data autentikasi.
///
/// Implementasi asli (REST API) nanti cukup mengganti [DummyAuthRepository],
/// sedangkan BLoC dan UI tidak perlu diubah.
abstract class AuthRepository {
  /// Login dengan email & kata sandi.
  ///
  /// Melempar [AuthException] bila kredensial salah.
  Future<UserModel> login({required String email, required String password});

  /// Mendaftarkan akun baru sesuai peran yang dipilih.
  Future<UserModel> register({
    required String nama,
    required String email,
    required String password,
    required String nomorWhatsapp,
    required UserRole role,
    int? kamarId,
  });

  /// Mengambil sesi yang tersimpan di perangkat (auto-login).
  ///
  /// Mengembalikan `null` bila belum pernah login.
  Future<UserModel?> restoreSession();

  /// Menghapus sesi tersimpan (logout).
  Future<void> logout();
}

/// Implementasi sementara tanpa backend.
///
/// Tujuannya agar alur Login -> Dashboard dan pengecekan `role_user` bisa
/// diuji end-to-end sebelum API tersedia. Ganti dengan implementasi Dio saat
/// backend siap, tanpa mengubah BLoC maupun UI.
class DummyAuthRepository implements AuthRepository {
  DummyAuthRepository({this.latency = const Duration(milliseconds: 600)});

  /// Jeda buatan agar indikator loading terlihat wajar saat demo.
  final Duration latency;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(latency);

    if (password.length < 8) {
      throw const AuthException(
        'Email atau kata sandi salah.',
        code: 'invalid_credentials',
      );
    }

    // Email berakhiran @pemilik.test -> pemilik, selain itu penghuni.
    final bool isPemilik = email.toLowerCase().endsWith('@pemilik.test');

    return UserModel(
      id: isPemilik ? 1 : 2,
      nama: isPemilik ? 'Maulana Gading' : 'Bagus Wihandono',
      email: email,
      role: isPemilik ? UserRole.pemilik : UserRole.penghuni,
      nomorWhatsapp: '081234567890',
      kamarId: isPemilik ? null : 4,
      namaKamar: isPemilik ? null : 'Kamar A-04 (Lantai 1, AC)',
    );
  }

  @override
  Future<UserModel> register({
    required String nama,
    required String email,
    required String password,
    required String nomorWhatsapp,
    required UserRole role,
    int? kamarId,
  }) async {
    await Future<void>.delayed(latency);

    return UserModel(
      id: 3,
      nama: nama,
      email: email,
      role: role,
      nomorWhatsapp: nomorWhatsapp,
      kamarId: kamarId,
      namaKamar: kamarId == null ? null : 'Kamar A-04 (Lantai 1, AC)',
    );
  }

  @override
  Future<UserModel?> restoreSession() async {
    // Belum ada penyimpanan sesi pada tahap dummy.
    return null;
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(latency);
  }
}
