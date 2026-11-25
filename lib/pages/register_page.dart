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
import '../models/user_role.dart';
import 'login_page.dart';

/// Halaman Daftar Akun Baru KosAsih.
///
/// Halaman ini dihubungkan ke [LoginKosAsihPage] lewat named route,
/// jadi user bisa bolak-balik Login <-> Register dalam satu aplikasi.
class RegisterKosAsihPage extends StatefulWidget {
  const RegisterKosAsihPage({super.key});

  /// Nama route, dipakai oleh `main.dart` dan halaman Login.
  static const String routeName = '/register';

  @override
  State<RegisterKosAsihPage> createState() => _RegisterKosAsihPageState();
}

class _RegisterKosAsihPageState extends State<RegisterKosAsihPage> {
  // Controller dibuat sekali di State (bukan di dalam build) supaya isi field
  // tidak ter-reset dan tidak bocor memorinya.
  final TextEditingController _nameController = TextEditingController(
    text: 'Bagus Wihandono',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'bagus@email.com',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '081234567890',
  );
  final TextEditingController _roomController = TextEditingController(
    text: 'Kamar A-04 (Lantai 1, AC)',
  );
  final TextEditingController _passwordController = TextEditingController();

  /// Peran yang dipilih pada tab "Daftar Sebagai".
  UserRole _selectedRole = UserRole.penghuni;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _roomController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String phone = _phoneController.text.trim();
    final String password = _passwordController.text;

    // Validasi form sebelum dikirim ke BLoC.
    final String? nameError = Validators.name(name);
    if (nameError != null) {
      CustomSnackbar.error(context, nameError);
      return;
    }
    final String? emailError = Validators.email(email);
    if (emailError != null) {
      CustomSnackbar.error(context, emailError);
      return;
    }
    final String? phoneError = Validators.phone(phone);
    if (phoneError != null) {
      CustomSnackbar.error(context, phoneError);
      return;
    }
    final String? passwordError = Validators.password(password);
    if (passwordError != null) {
      CustomSnackbar.error(context, passwordError);
      return;
    }

    // Pola wajib: UI mengirim Event, BLoC yang memproses.
    context.read<AuthBloc>().add(
      RegisterSubmitted(
        nama: name,
        email: email,
        password: password,
        nomorWhatsapp: phone,
        role: _selectedRole,
      ),
    );
  }

  /// Kembali ke halaman login.
  ///
  /// Kalau halaman ini dibuka lewat `push` dari login, cukup `pop`.
  /// Kalau dibuka langsung (mis. deep link), ganti route ke login.
  void _backToLogin() {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(LoginKosAsihPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthError) {
          CustomSnackbar.error(context, state.message);
        }
        if (state is AuthAuthenticated) {
          // Halaman ini dibuka lewat push di atas AuthGate, jadi harus
          // ditutup agar dashboard sesuai role_user terlihat.
          final NavigatorState navigator = Navigator.of(context);
          if (navigator.canPop()) navigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (BuildContext context, AuthState state) {
              final bool isLoading = state is AuthLoading;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // === Header ===
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: _backToLogin,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Kembali',
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.textPrimary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Daftar Akun Baru',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // === Pilihan Role ===
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Daftar Sebagai',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textLabel,
                          ),
                        ),
                        Text(
                          'Akses Penghuni',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Tab Pilihan: Penghuni Kos vs Pemilik Kos
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.tabBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: <Widget>[
                          // Tab Penghuni Kos
                          _RoleTab(
                            icon: Icons.person,
                            label: 'Penghuni Kos',
                            isActive: _selectedRole == UserRole.penghuni,
                            onTap: () => setState(
                              () => _selectedRole = UserRole.penghuni,
                            ),
                          ),

                          // Tab Pemilik Kos
                          _RoleTab(
                            icon: Icons.domain,
                            label: 'Pemilik Kos',
                            isActive: _selectedRole == UserRole.pemilik,
                            onTap: () => setState(
                              () => _selectedRole = UserRole.pemilik,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // === Form Input: Nama ===
                    const Text(
                      'Nama Lengkap',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: _nameController,
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),

                    // === Form Input: Email ===
                    const Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: _emailController,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // === Form Input: Nomor WhatsApp ===
                    const Text(
                      'Nomor WhatsApp',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: _phoneController,
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    // === Form Pilihan Kamar ===
                    const Row(
                      children: <Widget>[
                        Text(
                          'Pilih Kamar ',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '(Khusus Penghuni Kos)',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: _roomController,
                      prefixIcon: Icons.door_front_door_outlined,
                      isPicker: true,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),

                    // === Form Input: Kata Sandi ===
                    const Text(
                      'Kata Sandi',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: _passwordController,
                      prefixIcon: Icons.lock_outline,
                      hintText: 'Minimal 8 karakter',
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),

                    // === Ketentuan / Checkbox ===
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 18,
                          height: 18,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'Saya menyetujui ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4B5563),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Syarat & Ketentuan ',
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: 'sewa KosAsih.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // === Tombol Daftar Sekarang ===
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleRegister,
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
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'DAFTAR SEKARANG',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 18),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // === Navigasi Bawah ke Login ===
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Sudah punya akun? ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        AppTextLink(
                          label: 'Masuk di sini',
                          onTap: _backToLogin,
                        ),
                      ],
                    ),
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

/// Satu tab pilihan peran pada form Daftar.
class _RoleTab extends StatelessWidget {
  const _RoleTab({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: isActive
              ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                )
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 18,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
