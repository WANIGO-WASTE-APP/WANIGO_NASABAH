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
  // Fields not directly in API or need derivation
  final String? distance;
  final TimeOfDay? openTime;
  final TimeOfDay? closeTime;
  final String? information;
  final bool isVerified;

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
    this.distance,
    this.openTime,
    this.closeTime,
    this.information,
    this.isVerified = false,
  });

  factory WasteBankModel.fromJson(Map<String, dynamic> json) {
    return WasteBankModel(
      id: json['id'] ?? 0,
      name: json['nama_bank_sampah'] ?? '',
      code: json['kode_bank_sampah'],
      address: json['alamat_bank_sampah'] ?? '',
      description: json['deskripsi'] ?? '',
      latitude: double.tryParse(json['latitude']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '0') ?? 0.0,
      isActive: json['status_operasional'] ?? false,
      email: json['email'],
      phone: json['nomor_telepon_publik'],
      memberCode: json['kode_nasabah'],
      joinDate: json['tanggal_bergabung'],
      membershipStatus: json['status_keanggotaan'],
      distance: null,
      openTime: null,
      closeTime: null,
      information: null,
      isVerified: json['status_keanggotaan'] == 'aktif',
    );
  }
}
