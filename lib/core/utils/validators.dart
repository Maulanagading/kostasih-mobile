import '../constants/app_constants.dart';

/// Kumpulan validator form yang dipakai bersama.
///
/// Semua fungsi mengembalikan `null` bila valid, atau pesan error siap tampil
/// bila tidak valid — cocok dipakai langsung pada `TextFormField.validator`.
class Validators {
  const Validators._();

  static final RegExp _emailPattern = RegExp(
    r'^[\w.+-]+@[\w-]+\.[\w.-]+$',
  );

  static final RegExp _phonePattern = RegExp(r'^0[0-9]{8,13}$');

  /// Validasi email.
  static String? email(String? value) {
    final String text = (value ?? '').trim();
    if (text.isEmpty) return 'Email wajib diisi.';
    if (!_emailPattern.hasMatch(text)) return 'Format email tidak valid.';
    return null;
  }

  /// Validasi kata sandi (minimal [AppConstants.minPasswordLength] karakter).
  static String? password(String? value) {
    final String text = value ?? '';
    if (text.isEmpty) return 'Kata sandi wajib diisi.';
    if (text.length < AppConstants.minPasswordLength) {
      return 'Kata sandi minimal ${AppConstants.minPasswordLength} karakter.';
    }
    return null;
  }

  /// Validasi nomor WhatsApp/HP Indonesia, contoh: `081234567890`.
  static String? phone(String? value) {
    final String text = (value ?? '').trim();
    if (text.isEmpty) return 'Nomor WhatsApp wajib diisi.';
    if (!_phonePattern.hasMatch(text)) {
      return 'Nomor WhatsApp tidak valid (contoh: 081234567890).';
    }
    return null;
  }

  /// Validasi field teks wajib isi.
  static String? required(String? value, {String label = 'Field'}) {
    if ((value ?? '').trim().isEmpty) return '$label wajib diisi.';
    return null;
  }

  /// Validasi nama minimal 3 karakter.
  static String? name(String? value) {
    final String text = (value ?? '').trim();
    if (text.isEmpty) return 'Nama lengkap wajib diisi.';
    if (text.length < 3) return 'Nama minimal 3 karakter.';
    return null;
  }
}
