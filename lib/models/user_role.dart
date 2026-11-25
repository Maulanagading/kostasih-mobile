/// Peran pengguna aplikasi KosAsih (`role_user` pada REST API).
///
/// Satu basis kode APK menyesuaikan menu dan navigasi berdasarkan peran ini,
/// sehingga pengecekan hak akses cukup membandingkan enum ini.
enum UserRole {
  /// Pemilik kos: kelola kamar, penghuni, tagihan, verifikasi pembayaran.
  pemilik,

  /// Penghuni kos: lihat tagihan, bayar, lapor tamu, kirim komplain.
  penghuni;

  /// Nilai yang dipakai pada payload API.
  String get apiValue => name;

  /// Label yang ditampilkan di UI.
  String get label {
    switch (this) {
      case UserRole.pemilik:
        return 'Pemilik Kos';
      case UserRole.penghuni:
        return 'Penghuni Kos';
    }
  }

  /// Mengubah nilai dari API menjadi [UserRole].
  ///
  /// Melempar [ArgumentError] bila nilainya tidak dikenal, supaya kesalahan
  /// data dari server cepat ketahuan alih-alih diam-diam memakai default.
  static UserRole fromApi(String value) {
    final String normalized = value.trim().toLowerCase();
    for (final UserRole role in UserRole.values) {
      if (role.name == normalized) return role;
    }
    throw ArgumentError('Role tidak dikenal: "$value"');
  }

  /// Sama seperti [fromApi] tetapi mengembalikan `null` alih-alih melempar.
  static UserRole? tryFromApi(String? value) {
    if (value == null) return null;
    try {
      return fromApi(value);
    } on ArgumentError {
      return null;
    }
  }
}
