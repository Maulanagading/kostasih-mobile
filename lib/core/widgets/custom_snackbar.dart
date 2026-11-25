import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Snackbar terpusat untuk pesan sukses / error / info.
///
/// Kontrak tim: seluruh error bisnis dari Repository dipetakan menjadi State
/// error pada BLoC, lalu ditampilkan lewat helper ini agar tampilannya seragam.
class CustomSnackbar {
  const CustomSnackbar._();

  static const Duration _duration = Duration(seconds: 3);

  /// Pesan berhasil (hijau).
  static void success(BuildContext context, String message) {
    _show(context, message, const Color(0xFF15803D), Icons.check_circle_outline);
  }

  /// Pesan gagal / error bisnis (merah).
  static void error(BuildContext context, String message) {
    _show(context, message, const Color(0xFFB91C1C), Icons.error_outline);
  }

  /// Pesan informasi netral (biru).
  static void info(BuildContext context, String message) {
    _show(context, message, AppColors.primary, Icons.info_outline);
  }

  static void _show(
    BuildContext context,
    String message,
    Color background,
    IconData icon,
  ) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: background,
          duration: _duration,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Row(
            children: <Widget>[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
