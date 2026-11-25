# KosAsih Mobile

Aplikasi manajemen operasional dan keuangan indekos berbasis mobile yang dibangun menggunakan Flutter. KosAsih dirancang untuk membantu pemilik indekos mengelola kamar, penghuni, serta informasi keuangan dari satu aplikasi.

## Fitur

- Beranda dengan ringkasan pengelolaan indekos.
- Menu data kamar dan ketersediaan kamar.
- Menu data penghuni.
- Menu pengelolaan pembayaran dan keuangan.
- Struktur aplikasi yang siap dikembangkan untuk autentikasi dan dashboard.

## Teknologi

- Flutter & Dart
- Material 3
- Flutter Lints
- `flutter_bloc` + `equatable` — state management (pola Event → Bloc → State)
- `intl` — format tanggal & angka
- `dio` — klien HTTP untuk lapisan Repository
- `flutter_dotenv` — konfigurasi non-rahasia
- `shared_preferences` — penyimpanan sesi login
- `image_picker`, `pdf`, `printing` — unggah bukti bayar & E-Kuitansi

## Persyaratan

- Flutter stable 3.47.9 / Dart SDK `3.13.7` atau lebih baru.
- Android Studio atau Visual Studio Code dengan Flutter extension.
- Emulator Android, perangkat Android, atau target desktop/web yang didukung Flutter.

## Menjalankan proyek

```bash
git clone https://github.com/Maulanagading/kostasih-mobile.git
cd kostasih-mobile
flutter pub get
cp .env.example .env    # Windows: Copy-Item .env.example .env
flutter run
```

Berkas `.env` hanya berisi konfigurasi non-rahasia (mis. `API_BASE_URL`) dan
tidak ikut di-commit. Berkas rahasia lain seperti `google-services.json`,
`*.jks`, dan `key.properties` juga dilarang di-commit.

Untuk menjalankan pemeriksaan kualitas kode dan test:

```bash
flutter analyze
flutter test
```

## Struktur utama

```text
lib/
├── main.dart            # Entry point: MultiBlocProvider + AuthGate
├── core/                # Kode bersama: constants, theme, utils, widgets
├── models/              # Model data (UserModel, UserRole, dst.)
├── repositories/        # Kontrak akses data/API
├── blocs/               # State management per fitur (pola BLoC)
└── pages/               # Satu berkas per halaman
test/
├── blocs/               # Unit test BLoC
├── core/                # Unit test utilitas (formatRupiah, DateHelper)
└── widget_test.dart     # Widget test alur Login & redirect role
```

## Konvensi penting

- Nominal uang disimpan sebagai `int` Rupiah penuh dan ditampilkan lewat
  `formatRupiah()`.
- Semua perhitungan tanggal memakai `DateHelper` dengan zona `Asia/Jakarta`.
- UI tidak memanggil API langsung: gunakan pola BLoC (Event → Bloc → State).
- Error bisnis dipetakan menjadi state error BLoC dan ditampilkan lewat
  `CustomSnackbar`.

Panduan kerja tim (alur branch, commit, PR, dan pembagian modul) ada di
[`docs/TEAM_GUIDE.md`](docs/TEAM_GUIDE.md).

## Status pengembangan

Proyek ini sedang dikembangkan sebagai aplikasi manajemen indekos untuk kebutuhan pembelajaran Pemrograman Berbasis Mobile. Fitur akan bertambah secara bertahap sesuai kebutuhan analisis dan rancangan aplikasi.

Fondasi yang sudah tersedia: autentikasi berbasis BLoC dengan redirect sesuai
`role_user` (pemilik/penghuni), helper format Rupiah & tanggal WIB, model
pengguna, serta contoh repository. Modul kamar, penghuni, tamu, tagihan,
pembayaran, komplain, dan notifikasi dikerjakan pada fase berikutnya.

## Lisensi

Proyek ini belum menetapkan lisensi publik.