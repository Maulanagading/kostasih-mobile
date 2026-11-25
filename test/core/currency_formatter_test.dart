import 'package:flutter_test/flutter_test.dart';

import 'package:kostasih_mobile/core/utils/currency_formatter.dart';

void main() {
  group('formatRupiah', () {
    test('menampilkan nominal nol', () {
      expect(formatRupiah(0), 'Rp 0');
    });

    test('tanpa pemisah ribuan di bawah seribu', () {
      expect(formatRupiah(500), 'Rp 500');
      expect(formatRupiah(999), 'Rp 999');
    });

    test('menyisipkan titik setiap tiga digit', () {
      expect(formatRupiah(1000), 'Rp 1.000');
      expect(formatRupiah(1200000), 'Rp 1.200.000');
      expect(formatRupiah(12500000), 'Rp 12.500.000');
    });

    test('menangani nominal negatif', () {
      expect(formatRupiah(-50000), '-Rp 50.000');
    });

    test('formatNumber tanpa awalan Rp', () {
      expect(CurrencyFormatter.formatNumber(1200000), '1.200.000');
      expect(CurrencyFormatter.formatNumber(-1500), '-1.500');
    });
  });
}
