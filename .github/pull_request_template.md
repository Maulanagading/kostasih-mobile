## Deskripsi

<!-- Jelaskan perubahan ini secara singkat: apa yang diubah dan mengapa. -->

...

## Jenis Perubahan

- [ ] `feat` — fitur baru
- [ ] `fix` — perbaikan bug
- [ ] `refactor` — perubahan struktur tanpa mengubah perilaku
- [ ] `test` — menambah/memperbaiki pengujian
- [ ] `docs` — dokumentasi
- [ ] `chore` — konfigurasi/dependency

## Modul yang Disentuh

- [ ] Auth & Role Redirect
- [ ] Kamar
- [ ] Penghuni
- [ ] Tamu
- [ ] Tagihan & E-Kuitansi
- [ ] Pembayaran
- [ ] Komplain / Tiket
- [ ] Notifikasi (FCM)
- [ ] Core / Shared (theme, util, konstanta)

## Checklist Definition of Done

Wajib dicentang sebelum PR diminta review:

- [ ] Branch dibuat dari `develop` terbaru dan nama branch mengikuti `feature/kebab-case`
- [ ] `flutter analyze` bersih (**No issues found!**)
- [ ] `flutter test` lulus semua
- [ ] Perubahan dibuat dalam minimal 3 commit bermakna dengan format Conventional Commits
- [ ] Tidak ada berkas rahasia ikut ter-commit (`.env`, `google-services.json`, `*.jks`, `key.properties`)
- [ ] Tidak ada folder `build/` atau berkas hasil generate yang ikut ter-commit
- [ ] Alur data memakai pola BLoC (Event -> Bloc -> State); UI tidak memanggil API langsung
- [ ] Error ditampilkan lewat `CustomSnackbar` dan dipetakan dari state error BLoC
- [ ] Nominal uang bertipe `int` Rupiah penuh dan ditampilkan lewat `formatRupiah()`
- [ ] Perhitungan tanggal memakai `DateHelper` (zona `Asia/Jakarta`), bukan `DateTime.now()` langsung
- [ ] Sudah diuji di perangkat/emulator (sebutkan tipe & versi Android)
- [ ] PR menargetkan branch `develop` (bukan `main`)

## Cara Menguji

<!-- Langkah reproduksi untuk reviewer. -->

1. `git checkout <branch-ini>`
2. `flutter pub get`
3. `cp .env.example .env`
4. `flutter run`
5. ...

## Tangkapan Layar

<!-- Tempel screenshot sebelum/sesudah bila ada perubahan UI. -->

## Catatan untuk Reviewer

<!-- Hal yang perlu perhatian khusus, keputusan desain, atau TODO lanjutan. -->

...
