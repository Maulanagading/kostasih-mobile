import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kostasih_mobile/main.dart';

void main() {
  testWidgets('Halaman Login tampil saat aplikasi dibuka', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KosAsihApp());

    expect(find.text('KosAsih'), findsOneWidget);
    expect(find.text('MASUK'), findsOneWidget);
    expect(find.text('Daftar Sekarang'), findsOneWidget);
  });

  testWidgets('Navigasi Login -> Register -> Login berjalan', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KosAsihApp());

    // Dari Login pindah ke Register.
    await tester.tap(find.text('Daftar Sekarang'));
    await tester.pumpAndSettle();

    expect(find.text('Daftar Akun Baru'), findsOneWidget);
    expect(find.text('DAFTAR SEKARANG'), findsOneWidget);

    // Dari Register kembali ke Login lewat tombol back.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('MASUK'), findsOneWidget);
  });
}
