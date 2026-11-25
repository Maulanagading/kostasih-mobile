import 'package:flutter/material.dart';

import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'theme/app_colors.dart';

/// Satu-satunya entry point aplikasi KosAsih.
///
/// Dulu Login dan Register masing-masing punya `void main()` sendiri sehingga
/// hanya bisa dijalankan salah satu. Sekarang keduanya didaftarkan sebagai
/// route di satu [MaterialApp], jadi satu aplikasi punya dua halaman yang
/// saling terhubung.
void main() => runApp(const KosAsihApp());

class KosAsihApp extends StatelessWidget {
  const KosAsihApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KosAsih',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: Colors.white,
      ),
      // Halaman pertama yang tampil saat aplikasi dibuka.
      initialRoute: LoginKosAsihPage.routeName,
      // Daftar halaman yang bisa dituju lewat Navigator.pushNamed(...).
      routes: <String, WidgetBuilder>{
        LoginKosAsihPage.routeName: (_) => const LoginKosAsihPage(),
        RegisterKosAsihPage.routeName: (_) => const RegisterKosAsihPage(),
      },
    );
  }
}
