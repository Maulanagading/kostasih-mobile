# KosAsih Mobile

Aplikasi manajemen operasional dan keuangan indekos berbasis mobile yang dibangun menggunakan Flutter. KosAsih dirancang untuk membantu pemilik indekos mengelola kamar, penghuni, serta informasi keuangan dari satu aplikasi.

## Fitur

- Beranda dengan ringkasan pengelolaan indekos.
- Menu data kamar dan ketersediaan kamar.
- Menu data penghuni.
- Menu pengelolaan pembayaran dan keuangan.
- Struktur aplikasi yang siap dikembangkan untuk autentikasi dan dashboard.

## Teknologi

- Flutter
- Dart
- Material 3
- Flutter Lints

## Persyaratan

- Flutter stable yang kompatibel dengan Dart SDK `3.13.7` atau lebih baru.
- Android Studio atau Visual Studio Code dengan Flutter extension.
- Emulator Android, perangkat Android, atau target desktop/web yang didukung Flutter.

## Menjalankan proyek

```bash
git clone https://github.com/Maulanagading/kostasih-mobile.git
cd kostasih-mobile
flutter pub get
flutter run
```

Untuk menjalankan pemeriksaan kualitas kode dan test:

```bash
flutter analyze
flutter test
```

## Struktur utama

```text
lib/
└── main.dart       # Entry point dan halaman utama aplikasi
test/
└── widget_test.dart
```

## Status pengembangan

Proyek ini sedang dikembangkan sebagai aplikasi manajemen indekos untuk kebutuhan pembelajaran Pemrograman Berbasis Mobile. Fitur akan bertambah secara bertahap sesuai kebutuhan analisis dan rancangan aplikasi.

## Lisensi

Proyek ini belum menetapkan lisensi publik.