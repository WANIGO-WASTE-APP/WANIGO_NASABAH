import 'package:flutter/material.dart';

class BankSampah {
  final int id;
  final String namaBankSampah;
  final String alamatBankSampah;

  BankSampah({
    required this.id,
    required this.namaBankSampah,
    required this.alamatBankSampah,
  });

  factory BankSampah.fromJson(Map<String, dynamic> json) {
    return BankSampah(
      id: json['id'],
      namaBankSampah: json['nama_bank_sampah'] ?? '',
      alamatBankSampah: json['alamat_bank_sampah'] ?? '',
    );
  }
}

class TipeJadwal {
  final int id;
  final String tipeJadwal;

  TipeJadwal({
    required this.id,
    required this.tipeJadwal,
  });

  factory TipeJadwal.fromJson(Map<String, dynamic> json) {
    return TipeJadwal(
      id: json['id'],
      tipeJadwal: json['tipe_jadwal'] ?? '',
    );
  }
}

class ScheduleItemModel {
  final int id;
  final int userId;
  final int bankSampahId;
  final int tipeJadwalId;
  final String? frekuensi;
  final String waktuMulai;
  final DateTime tanggalMulai;
  final String status;
  final int nomorUrut;
  final BankSampah bankSampah;
  final TipeJadwal tipeJadwal;

  ScheduleItemModel({
    required this.id,
    required this.userId,
    required this.bankSampahId,
    required this.tipeJadwalId,
    this.frekuensi,
    required this.waktuMulai,
    required this.tanggalMulai,
    required this.status,
    required this.nomorUrut,
    required this.bankSampah,
    required this.tipeJadwal,
  });

  factory ScheduleItemModel.fromJson(Map<String, dynamic> json) {
    return ScheduleItemModel(
      id: json['id'],
      userId: json['user_id'],
      bankSampahId: json['bank_sampah_id'],
      tipeJadwalId: json['tipe_jadwal_id'],
      frekuensi: json['frekuensi'],
      waktuMulai: json['waktu_mulai'] ?? '',
      tanggalMulai: DateTime.parse(json['tanggal_mulai']),
      status: json['status'] ?? '',
      nomorUrut: json['nomor_urut'] ?? 1,
      bankSampah: BankSampah.fromJson(json['bank_sampah']),
      tipeJadwal: TipeJadwal.fromJson(json['tipe_jadwal']),
    );
  }

  String get scheduleTypeLabel {
    if (tipeJadwal.tipeJadwal.toLowerCase().contains('pemilahan')) {
      return 'Jadwal Pemilahan Sampah';
    } else if (tipeJadwal.tipeJadwal.toLowerCase().contains('setoran')) {
      return 'Jadwal Setoran Sampah';
    }
    return tipeJadwal.tipeJadwal;
  }

  String get frequencyLabel {
    if (frekuensi == null || frekuensi!.isEmpty) return 'Rutin bulanan';
    switch (frekuensi!.toLowerCase()) {
      case 'harian':
        return 'Rutin harian';
      case 'mingguan':
        return 'Rutin mingguan';
      case 'bulanan':
        return 'Rutin bulanan';
      default:
        return 'Rutin ${frekuensi}';
    }
  }

  String get formattedDate {
    final months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${tanggalMulai.day} ${months[tanggalMulai.month]} ${tanggalMulai.year}';
  }

  Color get leftBorderColor {
    if (tipeJadwal.tipeJadwal.toLowerCase().contains('pemilahan')) {
      return const Color(0xFF1B4BFF); // Blue
    } else if (tipeJadwal.tipeJadwal.toLowerCase().contains('setoran')) {
      return const Color(0xFF2E7D32); // Green
    }
    return const Color(0xFF757575); // Gray
  }

  Color get chipBackgroundColor {
    if (tipeJadwal.tipeJadwal.toLowerCase().contains('pemilahan')) {
      return const Color(0xFF1B4BFF); // Blue
    } else if (tipeJadwal.tipeJadwal.toLowerCase().contains('setoran')) {
      return const Color(0xFF2E7D32); // Green
    }
    return const Color(0xFF757575); // Gray
  }
}
