import '../constants/app_constants.dart';

/// Helper tanggal & waktu dengan zona Asia/Jakarta (WIB).
///
/// Catatan penting:
/// - Dart tidak menyimpan informasi zona waktu pada [DateTime], jadi helper di
///   sini mengembalikan "wall-clock WIB": nilai [DateTime] yang komponen
///   tanggal/jam-nya sudah mewakili waktu Jakarta.
/// - Selalu gunakan helper ini, jangan memakai `DateTime.now()` langsung, agar
///   perhitungan H-7 / H-3 / Hari-H / H+1 konsisten di semua perangkat.
class DateHelper {
  const DateHelper._();

  /// Selisih WIB terhadap UTC dalam jam.
  static const int _wibOffsetHours = 7;

  /// Waktu sekarang dalam wall-clock WIB.
  static DateTime nowWib() {
    return DateTime.now().toUtc().add(const Duration(hours: _wibOffsetHours));
  }

  /// Mengubah [dateTime] apa pun menjadi wall-clock WIB.
  static DateTime toWib(DateTime dateTime) {
    return dateTime.toUtc().add(const Duration(hours: _wibOffsetHours));
  }

  /// Membuang komponen jam/menit/detik sehingga tersisa tanggal saja.
  static DateTime dateOnlyWib(DateTime dateTime) {
    final DateTime wib = toWib(dateTime);
    return DateTime(wib.year, wib.month, wib.day);
  }

  /// Selisih hari antara [from] dan [to] (dihitung per tanggal WIB).
  ///
  /// Positif bila [to] setelah [from], negatif bila sebelumnya.
  /// ```dart
  /// daysBetweenWib(jatuhTempo, sekarang) // -1 -> terlambat 1 hari
  /// ```
  static int daysBetweenWib(DateTime from, DateTime to) {
    final DateTime start = dateOnlyWib(from);
    final DateTime end = dateOnlyWib(to);
    return end.difference(start).inDays;
  }

  /// Selisih hari dari hari ini (WIB) ke [target].
  ///
  /// Berguna untuk menentukan status tagihan:
  /// `7` = H-7, `0` = Hari-H, `-1` = terlambat 1 hari.
  static int daysFromTodayWib(DateTime target) {
    return daysBetweenWib(nowWib(), target);
  }

  /// Nama bulan dalam Bahasa Indonesia (indeks 1-12).
  static const List<String> _namaBulan = <String>[
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  /// Format tanggal WIB: `25 November 2026`.
  static String formatTanggalWib(DateTime dateTime) {
    final DateTime wib = toWib(dateTime);
    return '${wib.day} ${_namaBulan[wib.month - 1]} ${wib.year}';
  }

  /// Format tanggal + jam WIB: `25 November 2026, 14:05`.
  static String formatTanggalJamWib(DateTime dateTime) {
    final DateTime wib = toWib(dateTime);
    final String jam = wib.hour.toString().padLeft(2, '0');
    final String menit = wib.minute.toString().padLeft(2, '0');
    return '${formatTanggalWib(dateTime)}, $jam:$menit';
  }

  /// Label status jatuh tempo berdasarkan selisih hari.
  ///
  /// ```dart
  /// labelJatuhTempo(7)  // 'H-7'
  /// labelJatuhTempo(0)  // 'Hari ini'
  /// labelJatuhTempo(-2) // 'Terlambat 2 hari'
  /// ```
  static String labelJatuhTempo(int selisihHari) {
    if (selisihHari > 0) return 'H-$selisihHari';
    if (selisihHari == 0) return 'Hari ini';
    return 'Terlambat ${selisihHari.abs()} hari';
  }

  /// Zona waktu aplikasi, dipakai untuk dokumentasi dan konfigurasi lain.
  static String get timezone => AppConstants.appTimezone;
}
