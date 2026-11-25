import 'package:flutter_test/flutter_test.dart';

import 'package:kostasih_mobile/core/utils/date_helper.dart';

void main() {
  group('DateHelper', () {
    test('nowWib menghasilkan wall-clock 7 jam lebih maju dari UTC', () {
      final Duration selisih = DateHelper.nowWib().difference(
        DateTime.now().toUtc(),
      );
      // Toleransi 1 menit untuk waktu eksekusi test.
      expect(selisih.inMinutes, closeTo(7 * 60, 1));
    });

    test('daysBetweenWib menghitung selisih hari', () {
      final DateTime awal = DateTime.utc(2026, 11, 25, 10);
      final DateTime akhir = DateTime.utc(2026, 11, 30, 9);

      expect(DateHelper.daysBetweenWib(awal, akhir), 5);
      expect(DateHelper.daysBetweenWib(akhir, awal), -5);
    });

    test('formatTanggalWib memakai nama bulan Indonesia', () {
      final DateTime tanggal = DateTime.utc(2026, 11, 25, 3); // 10:00 WIB
      expect(DateHelper.formatTanggalWib(tanggal), '25 November 2026');
    });

    test('labelJatuhTempo sesuai status tagihan', () {
      expect(DateHelper.labelJatuhTempo(7), 'H-7');
      expect(DateHelper.labelJatuhTempo(0), 'Hari ini');
      expect(DateHelper.labelJatuhTempo(-2), 'Terlambat 2 hari');
    });
  });
}
