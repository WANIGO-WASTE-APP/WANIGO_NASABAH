import 'package:flutter/material.dart';

class WasteBankModel {
  final int id;
  final String name;
  final String? code;
  final String address;
  final String description;
  final double latitude;
  final double longitude;
  final bool isActive;
  final String? email;
  final String? phone;
  final String? memberCode;
  final String? joinDate;
  final String? membershipStatus;
  final int? nasabahCount;
  final double? tonaseCount;
  // Fields not directly in API or need derivation
  final String? distance;
  final TimeOfDay? openTime;
  final TimeOfDay? closeTime;
  final String? information;
  final bool isVerified;
  // Schedule fields
  final String? depositType;
  final String? depositTime;
  final String? depositHour;

  const WasteBankModel({
    required this.id,
    required this.name,
    this.code,
    required this.address,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.isActive,
    this.email,
    this.phone,
    this.memberCode,
    this.joinDate,
    this.membershipStatus,
    this.nasabahCount,
    this.tonaseCount,
    this.distance,
    this.openTime,
    this.closeTime,
    this.information,
    this.isVerified = false,
    this.depositType,
    this.depositTime,
    this.depositHour,
  });

  WasteBankModel copyWith({
    int? id,
    String? name,
    String? code,
    String? address,
    String? description,
    double? latitude,
    double? longitude,
    bool? isActive,
    String? email,
    String? phone,
    String? memberCode,
    String? joinDate,
    String? membershipStatus,
    int? nasabahCount,
    double? tonaseCount,
    String? distance,
    TimeOfDay? openTime,
    TimeOfDay? closeTime,
    String? information,
    bool? isVerified,
    String? depositType,
    String? depositTime,
    String? depositHour,
  }) {
    return WasteBankModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      address: address ?? this.address,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isActive: isActive ?? this.isActive,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      memberCode: memberCode ?? this.memberCode,
      joinDate: joinDate ?? this.joinDate,
      membershipStatus: membershipStatus ?? this.membershipStatus,
      nasabahCount: nasabahCount ?? this.nasabahCount,
      tonaseCount: tonaseCount ?? this.tonaseCount,
      distance: distance ?? this.distance,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      information: information ?? this.information,
      isVerified: isVerified ?? this.isVerified,
      depositType: depositType ?? this.depositType,
      depositTime: depositTime ?? this.depositTime,
      depositHour: depositHour ?? this.depositHour,
    );
  }

  factory WasteBankModel.fromJson(Map<String, dynamic> json) {
    // If nested under 'bank_sampah', use that as the primary source for info
    final Map<String, dynamic> bankInfo = (json['bank_sampah'] is Map)
        ? Map<String, dynamic>.from(json['bank_sampah'])
        : json;

    final Map<String, dynamic> contactInfo = (json['contact_info'] is Map)
        ? Map<String, dynamic>.from(json['contact_info'])
        : (bankInfo['contact_info'] is Map)
            ? Map<String, dynamic>.from(bankInfo['contact_info'])
            : {};

    // ID parsing
    final rawId = bankInfo['id'] ?? json['id'];
    final id =
        int.tryParse(rawId?.toString() ?? '') ?? (rawId is int ? rawId : 0);

    // Coordinate parsing
    final latitude = double.tryParse(
            (bankInfo['latitude'] ?? json['latitude'])?.toString() ?? '0') ??
        0.0;
    final longitude = double.tryParse(
            (bankInfo['longitude'] ?? json['longitude'])?.toString() ?? '0') ??
        0.0;

    // Status Operasional parsing (can be bool or String like "Tutup" or "Aktif")
    final rawStatus =
        json['status_operasional'] ?? bankInfo['status_operasional'];
    bool isActive = false;
    if (rawStatus is bool) {
      isActive = rawStatus;
    } else if (rawStatus != null) {
      final s = rawStatus.toString().toLowerCase();
      isActive =
          s == 'aktif' || s == 'buka' || s == 'true' || s == '1' || s == 'open';
    }

    // Name and Address
    final name = (bankInfo['nama_bank_sampah'] ?? json['nama_bank_sampah'])
            ?.toString()
            .trim() ??
        '';
    final address = (bankInfo['alamat'] ??
            bankInfo['alamat_lengkap'] ??
            bankInfo['alamat_bank_sampah'] ??
            json['alamat'] ??
            json['alamat_lengkap'] ??
            json['alamat_bank_sampah'] ??
            '')
        .toString()
        .trim();

    // Contact info fallbacks
    final email = (json['email'] ?? bankInfo['email'] ?? contactInfo['email'])
        ?.toString()
        .trim();
    final phone = (json['nomor_telepon'] ??
            json['nomor_telepon_publik'] ??
            bankInfo['nomor_telepon'] ??
            contactInfo['phone'] ??
            contactInfo['phone_number'] ??
            contactInfo['nomor_telepon'])
        ?.toString()
        .trim();

    // Membership info
    final mStatus = (json['member_status'] ??
            json['status_keanggotaan'] ??
            json['membership_status'] ??
            json['status'])
        ?.toString()
        .trim()
        .toLowerCase();

    bool checkBool(dynamic val) {
      if (val == null) return false;
      if (val is bool) return val;
      final s = val.toString().toLowerCase().trim();
      return s == '1' ||
          s == 'true' ||
          s == 'yes' ||
          s == 'aktif' ||
          s == 'active' ||
          s == 'sudah terdaftar' ||
          s == 'nasabah';
    }

    final isVerified = checkBool(json['is_registered']) ||
        checkBool(bankInfo['is_registered']) ||
        checkBool(json['is_member']) ||
        checkBool(bankInfo['is_member']) ||
        checkBool(json['registered']) ||
        (mStatus != null &&
            (mStatus == 'aktif' ||
                mStatus == 'active' ||
                mStatus == 'nasabah' ||
                mStatus == 'approved' ||
                mStatus == 'verified' ||
                mStatus.contains('terdaftar')));

    // Numeric parsing helper
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString());
    }

    // Jadwal Setoran parsing
    final Map<String, dynamic> jadwalSetoran = (json['jadwal_setoran'] is Map)
        ? Map<String, dynamic>.from(json['jadwal_setoran'])
        : (bankInfo['jadwal_setoran'] is Map)
            ? Map<String, dynamic>.from(bankInfo['jadwal_setoran'])
            : {};

    return WasteBankModel(
      id: id,
      name: name,
      code: (json['kode_bank_sampah'] ?? bankInfo['kode_bank_sampah'])
          ?.toString(),
      address: address,
      description:
          (bankInfo['deskripsi'] ?? json['deskripsi'])?.toString() ?? '',
      latitude: latitude,
      longitude: longitude,
      isActive: isActive,
      email: email,
      phone: phone,
      memberCode:
          (json['kode_nasabah'] ?? bankInfo['kode_nasabah'])?.toString(),
      joinDate: (json['tanggal_bergabung'] ?? json['join_date'])?.toString(),
      membershipStatus: mStatus,
      nasabahCount: parseInt(json['jumlah_nasabah'] ??
          bankInfo['jumlah_nasabah'] ??
          json['nasabah_count'] ??
          bankInfo['nasabah_count']),
      tonaseCount: parseDouble(json['tonase_sampah'] ??
          bankInfo['tonase_sampah'] ??
          json['tonase_count'] ??
          bankInfo['tonase_count'] ??
          json['tonase'] ??
          bankInfo['tonase']),
      distance: null,
      openTime: null,
      closeTime: null,
      information: null,
      isVerified: isVerified,
      depositType: jadwalSetoran['tipe']?.toString(),
      depositTime: jadwalSetoran['waktu']?.toString(),
      depositHour: jadwalSetoran['jam']?.toString(),
    );
  }
}
