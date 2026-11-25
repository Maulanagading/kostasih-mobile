# Panduan Tim KosAsih Mobile

Dokumen ini menjelaskan cara kerja harian tim agar tiga orang bisa bekerja
paralel tanpa saling menimpa kode.

---

## 1. Prasyarat

Samakan versi tooling supaya hasil build identik:

```bash
flutter --version   # target: Flutter 3.47.9 / Dart 3.13.7
flutter doctor
```

Bila versi Flutter berbeda jauh, dependency seperti `image_picker`,
`printing`, dan `shared_preferences` bisa gagal resolve.

---

## 2. Alur Kerja Harian

### 2.1 Mulai mengerjakan sesuatu

```bash
git checkout develop
git pull origin develop
flutter pub get
cp .env.example .env      # Windows: Copy-Item .env.example .env
git checkout -b feature/nama-fitur
```

Nama branch memakai `kebab-case` dan diawali `feature/`:

| Orang | Branch |
|---|---|
| Gading (Tech Lead) | `feature/billing-receipt-core` |
| Bagus | `feature/room-tenant-ui` |
| Martin | `feature/ticket-payment-fcm` |

### 2.2 Selama mengerjakan

Commit kecil dan bermakna, format **Conventional Commits**:

```
feat(kamar): tambah form tambah kamar
fix(tagihan): perbaiki denda saat jatuh tempo hari libur
refactor(auth): pisahkan validasi form ke helper
test(pembayaran): tambah test verifikasi bukti transfer
docs(readme): perjelas cara menjalankan aplikasi
chore(deps): perbarui intl ke 0.20.3
```

Minimal **3 commit bermakna** per orang per fase. Hindari commit besar
seperti "update" atau "fix bug".

### 2.3 Sebelum push

```bash
flutter analyze   # harus "No issues found!"
flutter test      # harus "All tests passed!"
git push -u origin feature/nama-fitur
```

### 2.4 Membuat Pull Request

- Base branch: **`develop`** — jangan pernah `main`.
- Isi template PR yang sudah tersedia di `.github/pull_request_template.md`
  dan centang seluruh checklist Definition of Done.
- Minta minimal satu reviewer (Gading) sebelum merge.
- Setelah merge, hapus branch fitur.

---

## 3. Struktur Folder

```
lib/
├── main.dart                  Entry point: MultiBlocProvider + AuthGate
├── core/                      Dipakai bersama, JANGAN diubah sepihak
│   ├── constants/             app_constants.dart, app_routes.dart
│   ├── theme/                 app_colors.dart
│   ├── utils/                 currency_formatter, date_helper, validators
│   └── widgets/               app_text_field, app_text_link, custom_snackbar
├── models/                    user_model.dart, user_role.dart
├── repositories/              Kontrak akses data (auth_repository.dart)
├── blocs/                     State management per fitur
│   └── auth/                  auth_bloc, auth_event, auth_state
└── pages/                     Satu berkas per halaman
```

Aturan penempatan:

- Widget yang dipakai **lebih dari satu modul** → `lib/core/widgets/`.
- Widget khusus satu halaman → tetap di berkas halaman tersebut
  (contoh: `_RoleTab` di `register_page.dart`).
- Model data baru → `lib/models/`.
- Logika akses API → `lib/repositories/`, **bukan** di halaman.

---

## 4. Kontrak Kode

### 4.1 Nominal uang

```dart
// BENAR
final int nominal = 1200000;
Text(formatRupiah(nominal));   // "Rp 1.200.000"

// SALAH
final double nominal = 1200000.0;  // jangan pakai double untuk uang
Text('Rp $nominal');               // jangan format manual
```

### 4.2 Tanggal & jatuh tempo

```dart
// BENAR
final int sisaHari = DateHelper.daysFromTodayWib(jatuhTempo);
Text(DateHelper.labelJatuhTempo(sisaHari));  // "H-7" / "Hari ini" / "Terlambat 2 hari"

// SALAH
final int sisaHari = jatuhTempo.difference(DateTime.now()).inDays;
```

Semua perhitungan memakai zona `Asia/Jakarta` (`AppConstants.appTimezone`).

### 4.3 Pola BLoC

```dart
// 1. Event
class TagihanDimuat extends TagihanEvent { ... }

// 2. State
class TagihanLoading extends TagihanState { ... }
class TagihanLoaded extends TagihanState { final List<Tagihan> data; ... }

// 3. Bloc
class TagihanBloc extends Bloc<TagihanEvent, TagihanState> { ... }

// 4. UI — kirim event, jangan panggil repository
context.read<TagihanBloc>().add(const TagihanDimuat());
```

Contoh lengkap yang bisa diikuti: `lib/blocs/auth/`.

### 4.4 Error ke pengguna

```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthError) {
      CustomSnackbar.error(context, state.message);
    }
  },
  ...
)
```

### 4.5 RBAC

Peran pengguna ada di `UserModel.role` (`UserRole.pemilik` /
`UserRole.penghuni`). Sembunyikan menu yang tidak berhak, jangan hanya
menonaktifkannya:

```dart
if (user.isPemilik) ... // menu verifikasi pembayaran
```

---

## 5. Larangan

1. **Jangan commit berkas rahasia**: `.env`, `google-services.json`,
   `GoogleService-Info.plist`, `*.jks`, `key.properties`. Semuanya sudah
   masuk `.gitignore`.
2. **Jangan push langsung ke `main` atau `develop`.** Selalu lewat PR.
3. **Jangan mengubah `lib/core/` sendirian.** Diskusikan dulu karena
   berdampak ke semua modul.
4. **Jangan menambah dependency** tanpa persetujuan Tech Lead.
5. **Jangan memakai `double` untuk nominal uang.**

---

## 6. Pembagian Modul

| Orang | Branch | Cakupan |
|---|---|---|
| Gading | `feature/billing-receipt-core` | Tagihan, denda otomatis, E-Kuitansi PDF, fondasi core |
| Bagus | `feature/room-tenant-ui` | Auth & role redirect, UI modular, data kamar, penghuni, tamu |
| Martin | `feature/ticket-payment-fcm` | Verifikasi pembayaran, tiket komplain, notifikasi FCM |

---

## 7. Perintah Berguna

```bash
flutter analyze              # cek lint & error
flutter test                 # jalankan semua test
flutter test test/blocs      # jalankan test satu folder
dart format lib test         # rapikan format
flutter clean                # bersihkan build cache
git log --oneline -10        # lihat 10 commit terakhir
```
