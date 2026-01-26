import '../../core/utils/currency_formatter.dart';
import 'waste_bank_model.dart';

class WasteCatalogResponse {
  final bool success;
  final String message;
  final WasteCatalogData? data;

  WasteCatalogResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory WasteCatalogResponse.fromJson(Map<String, dynamic> json) {
    return WasteCatalogResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null ? WasteCatalogData.fromJson(json['data']) : null,
    );
  }
}

class WasteCatalogData {
  final WasteBankModel? bankSampah;
  final List<WasteCatalogItem> katalogSampah;
  final List<SubCategorySummary> subKategoriList;
  final CategoryInfo? infoKategori;

  WasteCatalogData({
    this.bankSampah,
    required this.katalogSampah,
    required this.subKategoriList,
    this.infoKategori,
  });

  factory WasteCatalogData.fromJson(Map<String, dynamic> json) {
    return WasteCatalogData(
      bankSampah: json['bank_sampah'] != null
          ? WasteBankModel.fromJson(json['bank_sampah'])
          : null,
      katalogSampah: (json['katalog_sampah'] as List?)
              ?.map((e) => WasteCatalogItem.fromJson(e))
              .toList() ??
          [],
      subKategoriList: (json['sub_kategori_list'] as List?)
              ?.map((e) => SubCategorySummary.fromJson(e))
              .toList() ??
          [],
      infoKategori: json['info_kategori'] != null
          ? CategoryInfo.fromJson(json['info_kategori'])
          : null,
    );
  }
}

class WasteCatalogItem {
  final int id;
  final int bankSampahId;
  final int subKategoriSampahId;
  final int kategoriSampah;
  final String namaItemSampah;
  final String hargaPerKg;
  final String deskripsiItemSampah;
  final String? caraPemilahan;
  final String? caraPengemasan;
  final String? gambarItemSampah;
  final bool statusAktif;
  final String createdAt;
  final String updatedAt;
  final String kategoriUtama;
  final WasteSubCategory? subKategori;
  final String hargaFormat;
  final String gambarUrl;

  String get formattedHargaPerKg =>
      CurrencyFormatter.format(double.tryParse(hargaPerKg) ?? 0);

  WasteCatalogItem({
    required this.id,
    required this.bankSampahId,
    required this.subKategoriSampahId,
    required this.kategoriSampah,
    required this.namaItemSampah,
    required this.hargaPerKg,
    required this.deskripsiItemSampah,
    this.caraPemilahan,
    this.caraPengemasan,
    this.gambarItemSampah,
    required this.statusAktif,
    required this.createdAt,
    required this.updatedAt,
    required this.kategoriUtama,
    this.subKategori,
    required this.hargaFormat,
    required this.gambarUrl,
  });

  factory WasteCatalogItem.fromJson(Map<String, dynamic> json) {
    return WasteCatalogItem(
      id: json['id'] ?? 0,
      bankSampahId: json['bank_sampah_id'] ?? 0,
      subKategoriSampahId: json['sub_kategori_sampah_id'] ?? 0,
      kategoriSampah: json['kategori_sampah'] ?? 0,
      namaItemSampah: json['nama_item_sampah'] ?? '',
      hargaPerKg: json['harga_per_kg'] ?? '0',
      deskripsiItemSampah: json['deskripsi_item_sampah'] ?? '',
      caraPemilahan: json['cara_pemilahan'],
      caraPengemasan: json['cara_pengemasahan'],
      gambarItemSampah: json['gambar_item_sampah'],
      statusAktif: json['status_aktif'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      kategoriUtama: json['kategori_utama'] ?? '',
      subKategori: json['sub_kategori'] != null
          ? WasteSubCategory.fromJson(json['sub_kategori'])
          : null,
      hargaFormat: json['harga_format'] ?? '',
      gambarUrl: json['gambar_url'] ?? '',
    );
  }
}

class WasteSubCategory {
  final int id;
  final int bankSampahId;
  final int kategoriSampahId;
  final WasteCategory? kategoriSampah;
  final String namaSubKategori;
  final String kodeSubKategori;
  final String slug;
  final String deskripsi;
  final String? icon;
  final String warna;
  final int urutan;
  final bool statusAktif;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  WasteSubCategory({
    required this.id,
    required this.bankSampahId,
    required this.kategoriSampahId,
    this.kategoriSampah,
    required this.namaSubKategori,
    required this.kodeSubKategori,
    required this.slug,
    required this.deskripsi,
    this.icon,
    required this.warna,
    required this.urutan,
    required this.statusAktif,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WasteSubCategory.fromJson(Map<String, dynamic> json) {
    return WasteSubCategory(
      id: json['id'] ?? 0,
      bankSampahId: json['bank_sampah_id'] ?? 0,
      kategoriSampahId: json['kategori_sampah_id'] ?? 0,
      kategoriSampah: json['kategori_sampah'] != null
          ? WasteCategory.fromJson(json['kategori_sampah'])
          : null,
      namaSubKategori: json['nama_sub_kategori'] ?? '',
      kodeSubKategori: json['kode_sub_kategori'] ?? '',
      slug: json['slug'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      icon: json['icon'],
      warna: json['warna'] ?? '#000000',
      urutan: json['urutan'] ?? 0,
      statusAktif: json['status_aktif'] ?? false,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class WasteCategory {
  final int id;
  final String namaKategori;
  final String kodeKategori;
  final String deskripsi;
  final String? icon;
  final String createdAt;
  final String updatedAt;

  WasteCategory({
    required this.id,
    required this.namaKategori,
    required this.kodeKategori,
    required this.deskripsi,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WasteCategory.fromJson(Map<String, dynamic> json) {
    return WasteCategory(
      id: json['id'] ?? 0,
      namaKategori: json['nama_kategori'] ?? '',
      kodeKategori: json['kode_kategori'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      icon: json['icon'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class SubCategorySummary {
  final int id;
  final String namaSubKategori;
  final String kodeSubKategori;
  final String warna;
  final int jumlahItem;

  SubCategorySummary({
    required this.id,
    required this.namaSubKategori,
    required this.kodeSubKategori,
    required this.warna,
    required this.jumlahItem,
  });

  factory SubCategorySummary.fromJson(Map<String, dynamic> json) {
    return SubCategorySummary(
      id: json['id'] ?? 0,
      namaSubKategori: json['nama_sub_kategori'] ?? '',
      kodeSubKategori: json['kode_sub_kategori'] ?? '',
      warna: json['warna'] ?? '#000000',
      jumlahItem: json['jumlah_item'] ?? 0,
    );
  }
}

class CategoryInfo {
  final int jumlahKering;
  final int jumlahBasah;

  CategoryInfo({
    required this.jumlahKering,
    required this.jumlahBasah,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      jumlahKering: json['jumlah_kering'] ?? 0,
      jumlahBasah: json['jumlah_basah'] ?? 0,
    );
  }
}
