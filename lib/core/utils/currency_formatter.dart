/// Helper format nominal uang.
///
/// Aturan kontrak tim:
/// - Semua nominal disimpan sebagai `int` Rupiah penuh (contoh: 1200000).
/// - Tampilan ke pengguna WAJIB lewat [formatRupiah] agar konsisten.
class CurrencyFormatter {
  const CurrencyFormatter._();

  /// Mengubah nominal integer menjadi teks Rupiah.
  ///
  /// ```dart
  /// formatRupiah(1200000) // 'Rp 1.200.000'
  /// formatRupiah(0)       // 'Rp 0'
  /// formatRupiah(-50000)  // '-Rp 50.000'
  /// ```
  static String format(int nominal) {
    final bool isNegative = nominal < 0;
    final String digits = _withThousandSeparator(nominal.abs());
    return isNegative ? '-Rp $digits' : 'Rp $digits';
  }

  /// Sama seperti [format], tanpa awalan "Rp".
  ///
  /// Dipakai saat nominal sudah berada di dalam label yang menyebut Rupiah,
  /// misalnya kolom tabel laporan.
  static String formatNumber(int nominal) {
    final bool isNegative = nominal < 0;
    final String digits = _withThousandSeparator(nominal.abs());
    return isNegative ? '-$digits' : digits;
  }

  /// Menyisipkan titik sebagai pemisah ribuan.
  static String _withThousandSeparator(int value) {
    final String text = value.toString();
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      final int remaining = text.length - i;
      buffer.write(text[i]);
      // Setelah karakter ini masih ada sisa digit, dan posisi saat ini
      // adalah kelipatan tiga dari belakang -> tambahkan titik.
      if (remaining > 1 && remaining % 3 == 1) {
        buffer.write('.');
      }
    }
    return buffer.toString();
  }
}

/// Pintasan agar pemanggilan di UI tetap ringkas: `formatRupiah(1200000)`.
String formatRupiah(int nominal) => CurrencyFormatter.format(nominal);
