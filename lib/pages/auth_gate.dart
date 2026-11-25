import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import 'dashboard_pemilik_page.dart';
import 'dashboard_penghuni_page.dart';
import 'login_page.dart';

/// Penentu halaman pertama berdasarkan status autentikasi dan `role_user`.
///
/// Ini implementasi RBAC di sisi navigasi:
/// - belum login / sesi berakhir -> halaman Login,
/// - `role_user = pemilik`      -> Dashboard Pemilik,
/// - `role_user = penghuni`     -> Dashboard Penghuni.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (BuildContext context, AuthState state) {
        if (state is AuthInitial || state is AuthChecking) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthAuthenticated) {
          if (state.user.isPemilik) {
            return const DashboardPemilikPage();
          }
          return DashboardPenghuniPage(user: state.user);
        }

        return const LoginKosAsihPage();
      },
    );
  }
}
