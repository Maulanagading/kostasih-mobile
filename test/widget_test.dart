import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kostasih_mobile/main.dart';

/// Mengisi form login lalu menekan tombol MASUK.
Future<void> _login(
  WidgetTester tester, {
  required String email,
  required String password,
}) async {
  await tester.pumpWidget(const KosAsihApp());
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField).first, email);
  await tester.enterText(find.byType(TextField).last, password);

  await tester.tap(find.text('MASUK'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Halaman Login tampil saat aplikasi dibuka', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KosAsihApp());
    await tester.pumpAndSettle();

    expect(find.text('KosAsih'), findsOneWidget);
    expect(find.text('MASUK'), findsOneWidget);
    expect(find.text('Daftar Sekarang'), findsOneWidget);
  });

  testWidgets('Navigasi Login -> Register -> Login berjalan', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KosAsihApp());
    await tester.pumpAndSettle();

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

  testWidgets('Login pemilik diarahkan ke Dashboard Pemilik', (
    WidgetTester tester,
  ) async {
    await _login(tester, email: 'gading@pemilik.test', password: 'password123');

    // RBAC: role pemilik -> Dashboard Pemilik.
    expect(find.text('Mode Pemilik'), findsOneWidget);
    expect(find.text('Selamat Datang, Bu Asih 👋'), findsOneWidget);
  });

  testWidgets('Login penghuni diarahkan ke Dashboard Penghuni', (
    WidgetTester tester,
  ) async {
    await _login(tester, email: 'bagus@penghuni.test', password: 'password123');

    // RBAC: role penghuni -> Dashboard Penghuni.
    expect(find.text('Halo, Bagus Wihandono'), findsOneWidget);
    expect(find.text('Mode Pemilik'), findsNothing);
  });

  testWidgets('Login dengan kata sandi kurang dari 8 karakter ditolak', (
    WidgetTester tester,
  ) async {
    await _login(tester, email: 'gading@mail.com', password: 'pendek');

    expect(find.text('Kata sandi minimal 8 karakter.'), findsOneWidget);
    // Tetap di halaman Login.
    expect(find.text('MASUK'), findsOneWidget);
  });
}
