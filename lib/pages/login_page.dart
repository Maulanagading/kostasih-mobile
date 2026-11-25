import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/validators.dart';
import '../core/widgets/app_text_field.dart';
import '../core/widgets/app_text_link.dart';
import '../core/widgets/custom_snackbar.dart';
import 'register_page.dart';

/// Halaman Login KosAsih.
///
/// Halaman ini dihubungkan ke [RegisterKosAsihPage] lewat named route,
/// sehingga login dan register menjadi satu alur aplikasi (bukan dua app).
class LoginKosAsihPage extends StatefulWidget {
  const LoginKosAsihPage({super.key});

  /// Nama route, dipakai oleh `main.dart` dan halaman Register.
  static const String routeName = '/login';

  @override
  State<LoginKosAsihPage> createState() => _LoginKosAsihPageState();
}

class _LoginKosAsihPageState extends State<LoginKosAsihPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    // Validasi form sebelum dikirim ke BLoC.
    final String? emailError = Validators.email(email);
    if (emailError != null) {
      CustomSnackbar.error(context, emailError);
      return;
    }
    final String? passwordError = Validators.password(password);
    if (passwordError != null) {
      CustomSnackbar.error(context, passwordError);
      return;
    }

    // Pola wajib: UI mengirim Event, BLoC yang memproses.
    // Redirect ke dashboard dilakukan oleh AuthGate berdasarkan role_user.
    context.read<AuthBloc>().add(
      LoginSubmitted(email: email, password: password),
    );
  }

  /// Pindah ke halaman Daftar Akun.
  void _openRegisterPage() {
    Navigator.of(context).pushNamed(RegisterKosAsihPage.routeName);
  }

  void _showSnackBar(String message) {
    CustomSnackbar.info(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthError) {
          CustomSnackbar.error(context, state.message);
        }
        // AuthAuthenticated tidak perlu Navigator di sini: AuthGate yang
        // memindahkan halaman sesuai role_user.
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (BuildContext context, AuthState state) {
              final bool isLoading = state is AuthLoading;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 60),

                    // === Header ===
                    Center(
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.home_filled,
                              color: AppColors.primary,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'KosAsih',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Manajemen Hunian Kos Terintegrasi',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    // === Form Email ===
                    const Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: _emailController,
                      prefixIcon: Icons.email_outlined,
                      hintText: 'Masukkan email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // === Form Kata Sandi ===
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Kata Sandi',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        AppTextLink(
                          label: 'Lupa Sandi?',
                          onTap: () =>
                              _showSnackBar('Fitur lupa sandi belum tersedia.'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: _passwordController,
                      prefixIcon: Icons.lock_outline,
                      hintText: 'Masukkan kata sandi',
                      isPassword: true,
                    ),
                    const SizedBox(height: 32),

                    // === Tombol Masuk ===
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'MASUK',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // === Navigasi ke halaman Daftar ===
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Belum punya akun? '),
                        AppTextLink(
                          label: 'Daftar Sekarang',
                          fontSize: 14,
                          onTap: _openRegisterPage,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
