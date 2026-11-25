import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_colors.dart';
import 'pages/auth_gate.dart';
import 'pages/dashboard_pemilik_page.dart';
import 'pages/dashboard_penghuni_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'repositories/auth_repository.dart';

/// Satu-satunya entry point aplikasi KosAsih.
///
/// Alur halaman ditentukan oleh [AuthGate] berdasarkan status autentikasi dan
/// `role_user`, sehingga Login, Register, dan kedua dashboard berada dalam satu
/// [MaterialApp].
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // `.env` hanya berisi konfigurasi non-rahasia (mis. API_BASE_URL).
  // Bila file belum ada, aplikasi tetap boleh jalan memakai nilai default.
  try {
    await dotenv.load();
  } catch (_) {
    // Diabaikan: .env belum dibuat (lihat .env.example).
  }

  runApp(const KosAsihApp());
}

class KosAsihApp extends StatelessWidget {
  const KosAsihApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AuthBloc>(
          create: (_) =>
              AuthBloc(repository: DummyAuthRepository())..add(const AuthStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'KosAsih',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          scaffoldBackgroundColor: Colors.white,
        ),
        // Halaman pertama ditentukan oleh status login & role pengguna.
        home: const AuthGate(),
        // Route tambahan agar halaman tetap bisa dituju lewat
        // Navigator.pushNamed(...) seperti sebelumnya.
        routes: <String, WidgetBuilder>{
          AppRoutes.login: (_) => const LoginKosAsihPage(),
          AppRoutes.register: (_) => const RegisterKosAsihPage(),
          AppRoutes.dashboardPemilik: (_) => const DashboardPemilikPage(),
          AppRoutes.dashboardPenghuni: (_) => const DashboardPenghuniPage(),
        },
      ),
    );
  }
}

