import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/user_model.dart';

/// Dashboard untuk pengguna dengan `role_user = penghuni`.
///
/// Halaman ini masih berupa placeholder: modul Penghuni Kos dikerjakan oleh
/// Bagus pada branch `feature/room-tenant-ui`. Struktur dan route-nya sudah
/// disiapkan agar `AuthGate` dapat mengarahkan penghuni ke sini.
class DashboardPenghuniPage extends StatelessWidget {
  const DashboardPenghuniPage({super.key, this.user});

  /// Nama route, dipakai oleh `main.dart` dan `AuthGate`.
  static const String routeName = '/dashboard-penghuni';

  /// Data pengguna yang sedang login (opsional saat pratinjau desain).
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'KosAsih',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: AppColors.primary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                user == null
                    ? 'Dashboard Penghuni'
                    : 'Halo, ${user!.nama}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Modul Penghuni Kos sedang dikerjakan.\n'
                'Halaman ini akan diisi pada fase berikutnya.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
