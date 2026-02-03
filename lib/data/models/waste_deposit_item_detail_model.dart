class WasteDepositItemDetailModel {
  final int id;
  final String nama;
  final String kategoriUtama;
  final String subKategori;
  final String deskripsi;
  final String? caraPemilahan;
  final String? caraPengemasan;
  final String? gambarUrl;
  final String beratFormat;
  final String hargaFormat;
  final String nilaiFormat;
  final String harga;

  WasteDepositItemDetailModel({
    required this.id,
    required this.nama,
    required this.kategoriUtama,
    required this.subKategori,
    required this.deskripsi,
    this.caraPemilahan,
    this.caraPengemasan,
    this.gambarUrl,
    required this.beratFormat,
    required this.hargaFormat,
    required this.nilaiFormat,
    required this.harga,
  });

  factory WasteDepositItemDetailModel.fromJson(Map<String, dynamic> json) {
    // The top-level 'item_sampah' in the 'data' field has convenient flattened fields
    final itemData = json['item_sampah'] ?? {};
    // The 'detail_setoran' has the formatting fields
    final detailData = json['detail_setoran'] ?? {};

    return WasteDepositItemDetailModel(
      id: itemData['id'] ?? 0,
      nama: itemData['nama'] ?? '',
      kategoriUtama: itemData['kategori_utama'] ?? '',
      subKategori: itemData['sub_kategori'] ?? '',
      deskripsi: itemData['deskripsi'] ?? '',
      caraPemilahan: itemData['cara_pemilahan'],
      caraPengemasan: itemData['cara_pengemasan'],
      gambarUrl: itemData['gambar_url'],
      beratFormat: detailData['berat_format'] ?? '0,00 kg',
      hargaFormat: detailData['harga_format'] ?? 'Rp 0',
      nilaiFormat: detailData['nilai_format'] ?? 'Rp 0',
      harga: (detailData['katalog_sampah']?['harga_per_kg'] ?? '0').toString(),
    );
  }
}
