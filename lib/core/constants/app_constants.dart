/// Konstanta global yang dipakai bersama seluruh modul KosAsih.
///
/// Nilai-nilai di sini adalah bagian dari kontrak tim, jadi jangan diubah
/// tanpa koordinasi karena modul lain ikut bergantung padanya.
class AppConstants {
  const AppConstants._();

  // === Waktu ===

  /// Zona waktu resmi aplikasi.
  ///
  /// Semua kalkulasi tanggal jatuh tempo (H-7, H-3, Hari-H, H+1) wajib
  /// memakai zona ini agar hasil denda konsisten di semua perangkat.
  static const String appTimezone = 'Asia/Jakarta';

  /// Locale Indonesia untuk format tanggal.
  static const String appLocale = 'id_ID';

  // === Batasan unggah berkas ===

  /// Ukuran maksimal unggahan (bukti transfer, foto komplain): 5 MB.
  static const int maxUploadBytes = 5 * 1024 * 1024;

  /// Ekstensi yang diizinkan untuk unggahan.
  static const List<String> allowedUploadExtensions = <String>['jpg', 'png', 'pdf'];

  /// Ekstensi gambar yang diizinkan (bukti transfer & foto kerusakan).
  static const List<String> allowedImageExtensions = <String>['jpg', 'png'];

  // === Aturan kata sandi ===

  /// Panjang minimal kata sandi.
  static const int minPasswordLength = 8;
}
