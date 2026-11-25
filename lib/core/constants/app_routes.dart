/// Nama-nama route aplikasi, dikumpulkan di satu tempat.
///
/// Tujuannya agar tidak ada penulisan string route yang tersebar dan salah
/// ketik. Setiap halaman tetap menyimpan `routeName` miliknya sendiri, lalu
/// nilainya dirujuk dari sini.
class AppRoutes {
  const AppRoutes._();

  /// Halaman login (halaman awal aplikasi).
  static const String login = '/login';

  /// Halaman daftar akun baru.
  static const String register = '/register';

  /// Dashboard untuk pengguna dengan `role_user = pemilik`.
  static const String dashboardPemilik = '/dashboard-pemilik';

  /// Dashboard untuk pengguna dengan `role_user = penghuni`.
  static const String dashboardPenghuni = '/dashboard-penghuni';
}
