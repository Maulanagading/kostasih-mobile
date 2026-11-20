import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kostasih_mobile/main.dart';

void main() {
  testWidgets('menampilkan halaman utama KosAsih', (WidgetTester tester) async {
    await tester.pumpWidget(const KosAsihApp());

    expect(find.text('KosAsih'), findsOneWidget);
    expect(find.text('Selamat datang di KosAsih'), findsOneWidget);
    expect(find.text('Data Kamar'), findsOneWidget);
    expect(find.text('Data Penghuni'), findsOneWidget);
    expect(find.text('Keuangan'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
