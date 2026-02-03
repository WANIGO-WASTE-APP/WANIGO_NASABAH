import 'waste_bank_model.dart';

class WasteDepositHistoryResponse {
  final bool success;
  final WasteDepositHistoryData? data;

  WasteDepositHistoryResponse({
    required this.success,
    this.data,
  });

  factory WasteDepositHistoryResponse.fromJson(Map<String, dynamic> json) {
    return WasteDepositHistoryResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? WasteDepositHistoryData.fromJson(json['data'])
          : null,
    );
  }
}

class WasteDepositHistoryData {
  final int currentPage;
  final List<WasteDepositHistoryModel> data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  WasteDepositHistoryData({
    required this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory WasteDepositHistoryData.fromJson(Map<String, dynamic> json) {
    return WasteDepositHistoryData(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List?)
              ?.map((e) => WasteDepositHistoryModel.fromJson(e))
              .toList() ??
          [],
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }
}

class WasteDepositHistoryModel {
  final int id;
  final int userId;
  final int bankSampahId;
  final String tanggalSetoran;
  final String waktuSetoran;
  final String totalSaldo;
  final String totalBerat;
  final String statusSetoran;
  final String kodeSetoranSampah;
  final int totalPoin;
  final String? catatanStatusSetoran;
  final String createdAt;
  final String updatedAt;
  final String totalBeratFormat;
  final String totalNilaiFormat;
  final int jumlahItem;
  final bool isCancelable;
  final WasteBankModel? bankSampah;

  WasteDepositHistoryModel({
    required this.id,
    required this.userId,
    required this.bankSampahId,
    required this.tanggalSetoran,
    required this.waktuSetoran,
    required this.totalSaldo,
    required this.totalBerat,
    required this.statusSetoran,
    required this.kodeSetoranSampah,
    required this.totalPoin,
    this.catatanStatusSetoran,
    required this.createdAt,
    required this.updatedAt,
    required this.totalBeratFormat,
    required this.totalNilaiFormat,
    required this.jumlahItem,
    required this.isCancelable,
    this.bankSampah,
  });

  factory WasteDepositHistoryModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> setoranInfo = (json['setoran'] is Map)
        ? Map<String, dynamic>.from(json['setoran'])
        : json;

    return WasteDepositHistoryModel(
      id: setoranInfo['id'] ?? 0,
      userId: setoranInfo['user_id'] ?? 0,
      bankSampahId: setoranInfo['bank_sampah_id'] ?? 0,
      tanggalSetoran: setoranInfo['tanggal_setoran'] ?? '',
      waktuSetoran: setoranInfo['waktu_setoran'] ?? '',
      totalSaldo: setoranInfo['total_saldo']?.toString() ?? '0.00',
      totalBerat: setoranInfo['total_berat']?.toString() ?? '0.00',
      statusSetoran: setoranInfo['status_setoran'] ?? '',
      kodeSetoranSampah: setoranInfo['kode_setoran_sampah'] ?? '',
      totalPoin: setoranInfo['total_poin'] ?? 0,
      catatanStatusSetoran: setoranInfo['catatan_status_setoran'],
      createdAt: setoranInfo['created_at'] ?? '',
      updatedAt: setoranInfo['updated_at'] ?? '',
      totalBeratFormat: setoranInfo['total_berat_format'] ?? '0,00 kg',
      totalNilaiFormat: setoranInfo['total_nilai_format'] ?? 'Rp 0',
      jumlahItem: setoranInfo['jumlah_item'] ??
          (setoranInfo['detail_setoran'] is List
              ? (setoranInfo['detail_setoran'] as List).length
              : 0),
      isCancelable:
          json['is_cancelable'] ?? setoranInfo['is_cancelable'] ?? false,
      bankSampah: setoranInfo['bank_sampah'] != null
          ? WasteBankModel.fromJson(setoranInfo['bank_sampah'])
          : null,
    );
  }
}
