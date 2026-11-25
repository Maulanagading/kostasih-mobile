import 'package:equatable/equatable.dart';

import 'user_role.dart';

/// Data pengguna yang sedang login.
///
/// Field mengikuti kontrak data tim. Nominal uang TIDAK ada di sini karena
/// berada pada model tagihan (`int` Rupiah penuh).
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
    this.nomorWhatsapp,
    this.kamarId,
    this.namaKamar,
    this.fcmToken,
  });

  /// ID pengguna dari server.
  final int id;

  /// Nama lengkap.
  final String nama;

  /// Email login.
  final String email;

  /// Peran pengguna (menentukan menu & hak akses).
  final UserRole role;

  /// Nomor WhatsApp, dipakai untuk tombol "Chat WA" milik pemilik.
  final String? nomorWhatsapp;

  /// ID kamar yang ditempati (khusus penghuni).
  final int? kamarId;

  /// Label kamar untuk tampilan, contoh: "Kamar A-04 (Lantai 1, AC)".
  final String? namaKamar;

  /// Token Firebase Cloud Messaging milik perangkat ini.
  final String? fcmToken;

  /// Apakah pengguna ini pemilik kos.
  bool get isPemilik => role == UserRole.pemilik;

  /// Apakah pengguna ini penghuni kos.
  bool get isPenghuni => role == UserRole.penghuni;

  /// Inisial nama untuk avatar, maksimal 2 huruf.
  String get inisial {
    final List<String> parts = nama
        .trim()
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts[1].substring(0, 1))
        .toUpperCase();
  }

  /// Membaca model dari payload API.
  ///
  /// Toleran terhadap perbedaan nama key (`role`/`role_user`,
  /// `nomor_whatsapp`/`no_wa`, `kamar_id`/`room_id`) karena backend masih
  /// dalam pengembangan.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final String roleRaw =
        (json['role'] ?? json['role_user'] ?? 'penghuni').toString();

    return UserModel(
      id: _asInt(json['id']),
      nama: (json['nama'] ?? json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: UserRole.tryFromApi(roleRaw) ?? UserRole.penghuni,
      nomorWhatsapp: _asNullableString(
        json['nomor_whatsapp'] ?? json['no_wa'] ?? json['phone'],
      ),
      kamarId: _asNullableInt(json['kamar_id'] ?? json['room_id']),
      namaKamar: _asNullableString(json['nama_kamar'] ?? json['room_name']),
      fcmToken: _asNullableString(json['fcm_token'] ?? json['fcmToken']),
    );
  }

  /// Mengubah model menjadi payload API.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'email': email,
      'role': role.apiValue,
      'nomor_whatsapp': nomorWhatsapp,
      'kamar_id': kamarId,
      'nama_kamar': namaKamar,
      'fcm_token': fcmToken,
    };
  }

  /// Salinan dengan sebagian field diganti.
  UserModel copyWith({
    int? id,
    String? nama,
    String? email,
    UserRole? role,
    String? nomorWhatsapp,
    int? kamarId,
    String? namaKamar,
    String? fcmToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      role: role ?? this.role,
      nomorWhatsapp: nomorWhatsapp ?? this.nomorWhatsapp,
      kamarId: kamarId ?? this.kamarId,
      namaKamar: namaKamar ?? this.namaKamar,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int? _asNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static String? _asNullableString(dynamic value) {
    if (value == null) return null;
    final String text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    nama,
    email,
    role,
    nomorWhatsapp,
    kamarId,
    namaKamar,
    fcmToken,
  ];
}
